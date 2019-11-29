data "aws_ami" "centos" {
  most_recent = true

  filter {
    name   = "name"
    values = ["CentOS Linux 7 x86_64 HVM EBS *"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["679593333241"]
}
resource "aws_instance" "web" {
  ami                         = "${data.aws_ami.centos.id}"
  instance_type               = "t2.micro"
  security_groups             = ["${aws_security_group.allow-ssh.name}"]
  key_name                    = "mykey"
  associate_public_ip_address = true

provisioner "remote-exec" {
    connection {
    type        = "ssh"
    user        = "centos"
    private_key = "${file("mykey.pem")}"
    host        = "${self.public_ip}" 
    }
    inline = ["sudo yum update -y"]
  }
  tags = {
    Name = "HelloWorld"
  }
}

resource "aws_security_group" "allow-ssh" {
name = "allow-ssh"

ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port = 22
    to_port = 22
    protocol = "tcp"
  }

  egress {
   from_port = 0
   to_port = 0
   protocol = "-1"
   cidr_blocks = ["0.0.0.0/0"]
 }
}



