variable "username" {
  description = "The username of the instances"
  type        = string
  default     = "ubuntu"
}

variable "key_name" {
  description = "The name of the key pair"
  type        = string
  default     = "cloudforge"
}

variable "public_key_path" {
  description = "Path to the public key to use for instances"
  type        = string
  default     = "cloudforge.pub"
}

variable "private_key_path" {
  description = "Path to the public key to use for instances"
  type        = string
  default     = "cloudforge.pem"
}

variable "k8s_install_path" {
  description = "Path to the script for Micro K8S Installation"
  type        = string
  default     = "../scripts/microk8s_install.sh"
}

variable "vpc_cidr_block" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "security_group_name" {
  description = "Name of the security group"
  type        = string
  default     = "cicd_security_group"
}

variable "ami_id" {
  description = "AMI ID for the instance - (default is ubuntu)"
  type        = string
  default     = "ami-0866a3c8686eaeeba"
}

variable "instance_type" {
  description = "Instance type for the EC2 instances"
  type        = string
  default     = "t2.medium"
}

variable "instance" {
  description = "Names of the instances to create"
  type        = list(string)
  default     = ["kubernetes-master", "kubernetes-node-dev", "kubernetes-node-prod"]
}

variable "s3_buckets" {
  description = "Names of the buckets to create"
  type        = list(string)
  default     = ["cicd-lajsgfhjkla", "tf-state-lajsgfhjkla"]
}

variable "availability_zone" {
  description = "Availability zone to launch instances"
  type        = string
  default     = "us-east-1a"
}


variable "inventory_filename" {
  description = "Filename for the inventory output"
  type        = string
  default     = "inventory.json"
}

variable "egress_rules" {
  description = "Egress rules for the security group"
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  default = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
}

variable "ingress_rules" {
  description = "Ingress rules for the security group"
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  default = [
    # SSH Access
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    # HTTPS Access (For web traffic)
    {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    # HTTP Access (For web traffic)
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    # Kubernetes API Server (for K3s server)
    {
      from_port   = 6443
      to_port     = 6443
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    # Kubelet API (for internal communication between nodes)
    {
      from_port   = 10250
      to_port     = 10250
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    # Flannel VXLAN (for networking between nodes)
    {
      from_port   = 8472
      to_port     = 8472
      protocol    = "udp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    # etcd communication ports (used in HA setups for internal etcd)
    {
      from_port   = 2379
      to_port     = 2380
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    # NodePort Range (for accessing Kubernetes services)
    {
      from_port   = 30000
      to_port     = 32767
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
}
