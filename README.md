# Wordpress on ECS

In a single VPC, deploy a wordpress application and web infrastructure which is highly available, elastically scalable and easily recoverable:

This project contains `terraform` files under terraform directory and `docker` files to provision a Wordpress service on top of AWS EC2 Container Service. It deploys by default in region `us-east-1` and spans two availability zones. Its a fully automated deployment of wordpress app to AWS Cloud using Infrastructure as Code approach with Terraform, docker and the CI/CD concepts and tools using Jenkins and CodeDeploy .


## Prerequisite
* You are already setup with AWS and are ready with IAM and policies .
* AWS SDK Install [awscli](http://docs.aws.amazon.com/cli/latest/userguide/installing.html)
* [Configure awscli](http://docs.aws.amazon.com/cli/latest/userguide/cli-chap-getting-started.html) with key and secret (`aws configure`)
* Install [Terraform](https://www.terraform.io/intro/getting-started/install.html)
* AWS Keypair to connect to EC2 Instances 
* tfvars file which contain all required variables 

## Terraform to setup AWS

In a single VPC, deploy a wordpress application and web infrastructure which is highly available, elastically scalable and easily recoverable , Terraform will create all required resources in AWS to run wordpress by using terraform configuration files under terraform folder, additionally it will create a jenkins as well pulled from [Jenkins](https://hub.docker.com/r/jamsheer/awscli-jenkins/), I am keeping terraform state in S3 , so that it can be used by multiple users

#### Initialize
```
terraform init -backend-config "bucket=terraform-state.wordpress" 
-backend-config "region=us-east-1" -backend-config "key=terraform.tfstate" 
-backend-config "access_key=<>" -backend-config "secret_key=<>"
```

#### Create Plan 

```
terraform plan -var-file=variables.tfvars -out terraform.plan terraform
```

#### Deploy the infrastructure 

```
terraform apply "terraform.plan"
```

## CI/CD pipeline(s) - Jenkins server 

A Jenkins pipeline to automatically deploy code changes to your wordpress application in #1 to the infrastructure in the VPC from a GitHub repo. Use CodeDeploy as the last step in your pipeline. The pipeline will result in a Blue-Green deployment of the WordPress application.


#### Install required plugins (if not already installed)
        Pipeline
        Docker Pipeline Plugin
        Credentials Plugin
        
#### Setup [credentials](https://wiki.jenkins.io/display/JENKINS/Credentials+Plugin) in Jenkin

* Add docker hub credentials ID must be `docker-credentials` as the pipeline will be getting secret credentials using this id
* Add github credentials(Get Personal access tokens Generate new token from github and add to jenkins secret text credentails)

#### Setup GitHub to get Jenkins Push notifications .

* In Services / Manage Jenkins (GitHub plugin) in Github
* Update Jenkins Hook Url" is the URL of your Jenkins server's webhook endpoint. For
example: http://ci.jenkins-ci.org/github-webhook/

#### Pipeline [Wordpress](https://github.com/jamsheer/wordpress-ecs/blob/jamsheer-patch-1/Jenkinsfile).

The Jenkinsfile is a pipe line to Build and Push Docker image to [Wordpress](https://hub.docker.com/r/jamsheer/wordpress/).
and later deploy using aws codedeploy as bluegreen deployment.



## Technical 
We want our wordpress to 
 - scale easily
 - be highly available
 - be secure

#### Making the wordpress container stateless
To achieve our goal of easy scalability we want to make our Wordpress container stateless, meaning that no particular data are attached to the host the container is running on. 
Wordpress text article content is stored on an external database so we're good on this side. We'll use a `RDS` mysql instance for that.
Wordpress static content is stored at path `/var/www/html/wp-content` of the container. We'll store this on some storage space shared between hosts and mounted in the container. We'll use the `EFS` service for that (AWS nfs as a service).

We also want to put our ECS instances in an autoscaling group and put an ELB with HTTP healthcheck in front of it (cloudwatch alarms for autoscaling not implemented yet).

#### High Availability
To achieve HA we'll span our autoscaling group in two different availability zones.
Our RDS and NFS services are accessible to those two zones but are not HA, we should add that for production deployement.

#### Security
We use a dedicated VPC for our project, associated restrictive security 
groups to instances and put our ECS instances, DB and NFS services in private subnets which access the internet through a NAT (ECS instances need to install nfs-utils at startup and pull ECR repo). Only The ELB resides in the public subnet.

#### Implemented architecture
(NAT and internet gateway are not shown for clarity purposes)
```
us-east-1
+--------------------------------------------------------------+
|                                                              |
|           +----------------+    +----------------+           |
|           |         +-----------------+          |           |
|           |         |      |ELB |     |          |           |
|public     |         +-----------------+          | public    |
|us-east-1a +----------------+ || +----------------+ us-east-1b|
|                              ||                              |
|           +----------------+ || +----------------+           |
|           |                | || |                |           |
|           | +------------+ | || | +------------+ |           |
|           | |ECS instance| | || | |ECS instance| |           |
|           | |            +^------^+            | |           |
|           | +-----^----^-+ |    | +-----^-----^+ |           |
|private    |       |    |   |    |       |     |  | private   |
|us-east-1a +----------------+    +----------------+ us-east-1b|
|                   |    |                |     |              |
|                +--+--+ +-------------+--+--+  |              |
|                | RDS |               | EFS |  |              |
|                +-----+               +-----+  |              |
|                      +------------------------+              |
+--------------------------------------------------------------+
```
# To improve
 - Lot of things to optimize in code base
 - implement log monitoring (Can use filebeat, Logstash, Kibana and ElasticSearch) 
 - set up CDN to serve static content (Cloudfront)
 - customize Wordpress image for performance (use nginx, php fpm, tweak perf parameters...)
 - customize Jenkins Image by adding Necessary Plugins
 - etc ..
