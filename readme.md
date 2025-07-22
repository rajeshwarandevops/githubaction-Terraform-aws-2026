 # Deploy VPC 
 # Deploy two public Subnets
 # Deploy EC2 instance
 # Deploy Security  group and allow ssh only from specific public ip ( My Public)
 # Validate ec2 instance connectivity via MobaXterm
 
 # https://hieven.github.io/terraform-visual/
   terraform show -json plan.out > plan.json
 # aws configure list-profiles