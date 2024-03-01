**Setup Terraform to Work with GCP**
To use terraform working with GCP you need:
- Create a bucket with unique name universally
- Create Service account for terraform to work with google apis in GCP with role and proper permissions:

you need to run the projects in the following order:
1. terraform
2. vault
3. infrastructure
4. any services under wms, etc. in any order you like.