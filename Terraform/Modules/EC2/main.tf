#data "aws_subnet" "public" {
  #id = var.public_subnet.id
#}
#data "aws_subnet" "private" {
 # id = var.private_subnet.id
#}
# Create an EC2 instance in AWS. This resource block defines the configuration of the instance.
resource "aws_instance" "FrontEnd"  {
  #add count when you want to make multiple resources
  count=2
  ami               = "ami-0866a3c8686eaeeba"                # The Amazon Machine Image (AMI) ID used to launch the EC2 instance.
                                        # Replace this with a valid AMI ID
  instance_type     = var.instance_type               # Specify the desired EC2 instance size.
  # Attach an existing security group to the instance.
  # Security groups control the inbound and outbound traffic to your EC2 instance.
  vpc_security_group_ids =  [aws_security_group.FrontEnd_SecurityGroup.id]        # Replace with the security group ID, e.g., "sg-01297adb7229b5f08".
  key_name          = "FrontEndKeyPair"                # The key pair name for SSH access to the instance.
  subnet_id = var.public_subnet[count.index]
  user_data         = file("${path.module}/Scripts/frontend_setup.sh")
    
  
  # Tagging the resource with a Name label. Tags help in identifying and organizing resources in AWS.
  tags = {
    "Name" : "ecommerce_frontend_az${count.index + 1}"         
  }
}

resource "aws_instance" "BackEnd"  {
  count=2
  ami               = "ami-0866a3c8686eaeeba"                # The Amazon Machine Image (AMI) ID used to launch the EC2 instance.
                                        # Replace this with a valid AMI ID
  instance_type     = var.instance_type               # Specify the desired EC2 instance size.
  # Attach an existing security group to the instance.
  # Security groups control the inbound and outbound traffic to your EC2 instance.
  vpc_security_group_ids =  [aws_security_group.BackEnd_SecurityGroup.id]        # Replace with the security group ID, e.g., "sg-01297adb7229b5f08".
  key_name          = "BackendKeyPair"                # The key pair name for SSH access to the instance.
  subnet_id = var.private_subnet[count.index]
  user_data = file("${path.module}/Scripts/backend_setup.sh")
  # Tagging the resource with a Name label. Tags help in identifying and organizing resources in AWS.
  tags = {
    "Name" : "ecommerce_backend_az${count.index + 1}"         
  }
}

# Create a security group named "tf_made_sg" that allows SSH and HTTP traffic.
# This security group will be associated with the EC2 instance created above.
resource "aws_security_group" "FrontEnd_SecurityGroup" { 
  
  name        = "frontEnd_sg" #name that will show up on AWS
  description = "open ssh traffic/ React"
  vpc_id = var.vpc_id
  # Ingress rules: Define inbound traffic that is allowed.Allow SSH traffic and HTTP traffic on port 8080 from any IP address (use with caution)
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }
  # Egress rules: Define outbound traffic that is allowed. The below configuration allows all outbound traffic from the instance.
egress {
    from_port   = 0    #allow all outbound traffic 
    to_port     = 0
    protocol    = "-1"  #all protocol
    cidr_blocks = ["0.0.0.0/0"] 
  }

  # Tags for the security group
  tags = {
    "Name"      : "frontend_sg"                          # Name tag for the security group
    "Terraform" : "true"                                # Custom tag to indicate this SG was created with Terraform
  }
}

# Output block to display the public IP address of the created EC2 instance.
# Outputs are displayed at the end of the 'terraform apply' command and can be accessed using `terraform output`.
# They are useful for sharing information about your infrastructure that you may need later (e.g., IP addresses, DNS names).
output "frontend_instance_ip" {
  value = aws_instance.FrontEnd[*]  # Display the public IP address of the EC2 instance after creation. Use * to get ip address for each instance created.
}

# Create a security group named "tf_made_sg" that allows SSH and HTTP traffic.
# This security group will be associated with the EC2 instance created above.
resource "aws_security_group" "BackEnd_SecurityGroup" { 
  
  name        = "BackEnd_sg" #name that will show up on AWS
  description = "open ssh traffic/ Django"
  vpc_id = var.vpc_id
  # Ingress rules: Define inbound traffic that is allowed.Allow SSH traffic and HTTP traffic on port 8080 from any IP address (use with caution)
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 8000
    to_port     = 8000
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }
   ingress {
    from_port   = 9100
    to_port     = 9100
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }
  # Egress rules: Define outbound traffic that is allowed. The below configuration allows all outbound traffic from the instance.
egress {
    from_port   = 0    #allow all outbound traffic 
    to_port     = 0
    protocol    = "-1"  #all protocol
    cidr_blocks = ["0.0.0.0/0"] 
  }

  # Tags for the security group
  tags = {
    "Name"      : "backend_sg"                          # Name tag for the security group
    "Terraform" : "true"                                # Custom tag to indicate this SG was created with Terraform
  }
}

# Output block to display the public IP address of the created EC2 instance.
# Outputs are displayed at the end of the 'terraform apply' command and can be accessed using `terraform output`.
# They are useful for sharing information about your infrastructure that you may need later (e.g., IP addresses, DNS names).
output "backend_instance_ip" {
  value = aws_instance.BackEnd[*]  # Display the public IP address of the EC2 instance after creation. Use * to get ip address for each instance created.
}

