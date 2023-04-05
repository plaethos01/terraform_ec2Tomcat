provider "aws" {
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  region     = var.aws_region
}

resource "aws_instance" "web" {
  ami           = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name
  security_groups = var.security_groups
  subnet_id     = var.subnet_id

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("${var.key_name}.pem")
    timeout     = "2m"
  }

  provisioner "file" {
    source      = "files/install_tomcat.sh"
    destination = "/home/ubuntu/install_tomcat.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /home/ubuntu/install_tomcat.sh",
      "sudo /home/ubuntu/install_tomcat.sh ${var.tomcat_admin_username} ${var.tomcat_admin_password}",
    ]
  }
}

output "public_ip" {
  value = aws_instance.web.public_ip
}

