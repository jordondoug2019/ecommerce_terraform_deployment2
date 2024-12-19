# eCommerce Terraform Deployment

## PURPOSE
The purpose of this workload is to automate the deployment of an eCommerce application using Terraform. This project enables the provisioning of AWS infrastructure, including VPCs, EC2 instances, and necessary networking components, while also facilitating a Continuous Integration/Continuous Deployment (CICD) pipeline for efficient application updates and management.

## STEPS
1. **Set Up AWS VPC**: 
   - Created a Virtual Private Cloud (VPC) to host all resources securely and isolated from other AWS accounts.
   - Important for network segmentation and security compliance.

2. **Provision EC2 Instances**: 
   - Launched EC2 instances for application servers, ensuring scalability and availability.
   - Each instance runs specific services required by the application, such as the web server and database.

3. **Configure Security Groups**: 
   - Defined inbound and outbound rules to control access to the EC2 instances.
   - Essential for protecting the application from unauthorized access while allowing necessary traffic.

4. **Set Up VPC Peering**: 
   - Established peering connections between VPCs to enable communication between different environments (e.g., development and production).
   - Ensures data transfer between services hosted in different VPCs.

## SYSTEM DESIGN DIAGRAM
![ecommerce-terraform-deployment drawio](https://github.com/user-attachments/assets/5c524016-3915-4fd7-a2d0-d732286ef834)



## ISSUES/TROUBLESHOOTING
- **Connectivity Issues**: Experienced difficulties in connecting the Prometheus server to the Node Exporter due to VPC peering configurations. Ensured that security groups and network ACLs were properly configured.
- **SSH Access Problems**: Encountered issues accessing EC2 instances via SSH. Resolved by verifying key pair configurations and security group rules.
- **Deployment Failures**: Faced deployment failures in the CICD pipeline due to incorrect Terraform configurations. Carefully reviewed logs to identify and fix configuration errors.


## OPTIMIZATION
- **IaC**: Further optimize Terraform scripts by modularizing resources, allowing for easier maintenance and reuse across different projects. Create Modules for Application Load Balancer, Vpc Peering, RDS, etc. 
- **CI/CD Pipeline**: Implement CI/CD Pipeline with Jenkins to automate deployment
- **Scaling Strategy**: Utilize AWS Auto Scaling to automatically adjust the number of EC2 instances based on traffic load, ensuring high availability and cost-efficiency.
- **Performance Monitoring**: Set up application performance monitoring tools to continuously track application health and respond proactively to potential issues.
- **Database Schema/Queries**: Create a Database Schema to effectively communicate the relationship between users and products. Display best selling products across in the top 5 states and closely examine the intersectionality of low performing products in low performing states.   

## CONCLUSION
The eCommerce Terraform deployment will provide a scalable infrastructure for running an online application. This workload simplifies the deployment processes but also enhances overall operational efficiency. Future optimizations will focus on performance monitoring and utilizing the CI/CD pipeline.

## Additional Sections (Optional)
- **Future Work**: Retry workload.
-

