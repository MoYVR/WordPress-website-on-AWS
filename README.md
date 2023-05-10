# Building a Scalable and Highly Available WordPress Website on AWS

This project showcases the use of Terraform to automate the infrastructure provisioning process for building a scalable and highly available WordPress website on AWS. The final output is a website that can handle high traffic loads and ensures the security and availability of the website using various AWS services.

## Solution Overview
The solution utilizes the following AWS services:

- **Amazon RDS**: Database solution for storing site data securely and efficiently.
- **Secrets Manager**: Securely manages the database password.
- **Auto Scaling**: Provisions multiple servers in HA mode to handle unexpected spikes in traffic and maintain high availability.
- **Load Balancer**: Distributes incoming requests across multiple web servers, improving the website's response time and reducing the risk of downtime.
- **Route53**: Connects to the website securely via user-friendly DNS names.
- **Amazon Certificate Manager**: Ensures traffic is encrypted using SSL/TLS.

Clear and concise architecture diagrams were created to describe the solution, including a networking diagram, security group layout, and user request flow diagram, making it easy to understand the solution during a potential interview. 

Testing and troubleshooting were conducted to identify and resolve any issues or vulnerabilities in the infrastructure and application, ensuring that the website is secure and reliable.

## Technologies Used
- Terraform
- AWS RDS
- AWS Secrets Manager
- AWS Auto Scaling
- AWS Load Balancer
- AWS Route53
- Amazon Certificate Manager

## Steps to Reproduce
To reproduce this solution, follow these steps:
1. Clone this repository.
2. Set up your AWS account credentials.
3. Modify the Terraform variables as needed.
4. Run the Terraform scripts to provision the infrastructure.
5. Deploy the WordPress application on the servers.
6. Configure the Load Balancer and Route53 to connect to the website securely.

## Conclusion
Using Terraform and AWS services, we have demonstrated how to build and deploy a scalable and highly available WordPress website on AWS. This solution ensures the security and availability of the website using various AWS services, such as RDS, Secrets Manager, Auto Scaling, Load Balancer, Route53, and Amazon Certificate Manager. The use of clear and concise architecture diagrams made it easy to understand the solution during a potential interview. Testing and troubleshooting were conducted to ensure that the website is secure and reliable.
