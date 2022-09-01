resource "aws_eip" "mongoeip" {
  instance = aws_instance.mongodb.id
  vpc      = true
}

resource "aws_network_interface" "mongo-eth0" {
  depends_on = [module.vpc]
  subnet_id   = module.vpc.public_subnets[0]
  private_ips = ["10.0.4.100"]
  security_groups = [aws_security_group.general_admin.id]


  tags = {
    Name = "primary_network_interface"
  }
}

resource "aws_instance" "mongodb" {
  ami           = "ami-0023040df18933030" 
  instance_type = "m1.large"
  key_name = aws_key_pair.deployer.key_name
  iam_instance_profile = aws_iam_instance_profile.mongo_profile.name

  network_interface {
    network_interface_id = aws_network_interface.mongo-eth0.id
    device_index         = 0
  }

  tags = {
      Name = "mongo-master"
      Owner = "Tom"
  }

  # Copy in the bash script we want to execute.
  # The source is the location of the bash script
  # on the local linux box you are executing terraform
  # from.  The destination is on the new AWS instance.
  provisioner "file" {
    source      = "./setup-mongo"
    destination = "/tmp/setup-mongo"
  }
  
  # Change permissions on bash script
  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/setup-mongo"
    ]
  }
  # Login to the ec2-user with the aws key.
  connection {
    type        = "ssh"
    user        = "ec2-user"
    password    = ""
    private_key = file("access-aws.pem")
    host        = self.public_ip
  }

  depends_on = [ aws_instance.mongodb ]
}

# Creates 4 volumes as per documentation
resource "aws_ebs_volume" "mongovol" {
  count = 4
  availability_zone = "us-east-1a"
  size              = 4
  tags = {
    Name = "volume-mongo-${count.index + 1}"
  }
}

# Attaches the volumes to the instance
resource "aws_volume_attachment" "ebs_att" {
  skip_destroy = "true"
  count = 4
  device_name = "/dev/sdh${count.index + 1}"
  volume_id   = aws_ebs_volume.mongovol[count.index].id
  instance_id = aws_instance.mongodb.id
}

