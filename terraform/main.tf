provider "aws" {
  region = "us-east-1"
}

resource "aws_key_pair" "minecraft_key" {
  key_name   = "minecraft_key"
  public_key = file("minecraft_key.pem.pub")
}

resource "aws_security_group" "minecraft_sg" {
  name        = "minecraft_sg"
  description = "Allow Minecraft traffic"

  ingress {
    from_port   = 25565
    to_port     = 25565
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
  from_port   = 22
  to_port     = 22
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "minecraft" {
  ami           = "ami-0731becbf832f281e" # Ubuntu 22.04 (update if needed)
  instance_type = "t2.medium"
  key_name      = aws_key_pair.minecraft_key.key_name
  security_groups = [aws_security_group.minecraft_sg.name]

  tags = {
    Name = "MinecraftServer"
  }

  lifecycle {
    create_before_destroy = true
  }

  provisioner "remote-exec" {
    inline = ["echo Hello"]
    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("minecraft_key.pem")
      host        = self.public_ip
    }
  }
}

output "public_ip" {
  value = aws_instance.minecraft.public_ip
}