**Setup Terraform to Work with GCP**

To use terraform working with GCP you need:
- Create a bucket with unique name universally that bucket name will be used in the backend.tf files.
- Create Service account you need to set the account id of that account in service_account.tf in infrastructure.
- Download the key of the service account and you need to set it in the github action GCP_CREDENTIALS secrets and variables.
- Grant the following permissions to created service account:
    * Service account admin
    * Storage object admin
    * Owner

you need to run the projects in the following order:
1. terraform
2. vault
3. infrastructure
4. any services under wms, etc. in any order you like.