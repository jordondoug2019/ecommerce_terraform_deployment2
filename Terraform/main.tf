provider "aws" {
    access_key = var.access_key
    secret_key = var.secret_key
    region = var.region
}


module "VPC"{
    source= "./Modules/VPC"
    vpc_id=module.VPC.vpc_id
    public_subnet= module.VPC.public_subnet_id
    private_subnet= module.VPC.private_subnet_id
    FrontEnd_SecurityGroup_id = module.EC2.FrontEnd_SecurityGroup
    Backend_SecurityGroup_id = module.EC2.BackEnd_SecurityGroup
    ec2_instance_ids = module.EC2.frontend_instance_ids 


}

module "EC2"{
    source= "./Modules/EC2"
    vpc_id=module.VPC.vpc_id
    public_subnet= module.VPC.public_subnet_id
    private_subnet= module.VPC.private_subnet_id
    FrontEnd_SecurityGroup_id = module.EC2.FrontEnd_SecurityGroup
    Backend_SecurityGroup_id = module.EC2.BackEnd_SecurityGroup
    
    
}

