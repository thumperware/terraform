**Setup Terraform to Work with GCP**
To use terraform working with GCP you need:
- Create a bucket with unique name universally
- Create Service account for terraform to work with google apis in GCP with role and proper permissions:

    * Service account admin
    * Storage object admin
    * Owner
```
NOTE: This account is different than the service account defined in the service_account.tf file. This account is being used to initialize GCP for very beginning of the project. you need to download the key json of this file and set it in your GCP_CREDENTIAL in the CICD pipeline.
```

Enable the following GCP services:
- Cloud storage(storage.googleapis.com)
- Artifact registry service(artifactregistry.googleapis.com)
- compute engine api(compute.googleapis.com)
- Kubernetes Engine(container.googleapis.com)
- Cloud Resource Manager API(cloudresourcemanager.googleapis.com)
- Service Networking API(servicenetworking.googleapis.com)
- Cloud SQL Admin API(sqladmin.googleapis.com)