variable "aws_region" {
  type    = string
  default = "af-south-1"
}

variable "instance_type" {
  type =  string
  default = "t3.small"
}

locals {
  instance_names_content = file("${path.module}/names.txt")
  instance_names       = compact(split("\n", local.instance_names_content))
}

output "instance_info" {
  value = [
    for idx, instance_name in local.instance_names : {
      name           = instance_name,
      public_ip      = aws_instance.af-ec2[idx].public_ip,
      connection_str = "ssh -i ${instance_name}.pem ubuntu@${aws_instance.af-ec2[idx].public_dns}",
    }
  ]
}
