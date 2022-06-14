# Kubernetes Helm Multi-Deploy

This action will deploy all Helm chart folders inside a 'deployment' folder in your repository root. For example:

- My-Awesome-Project
  - deployment
    - helm-chart-1
    - helm-chart-2
    - ...
  - src
  - README.md


| **Input**        | **Required** | **Default**                 | **Description**                                                                                        |
|------------------|--------------|-----------------------------|--------------------------------------------------------------------------------------------------------|
| image-tag        | yes          | N/A                         | Image tag to use in each deployment.                                                                   |
| k8s-namespace    | yes          | N/A                         | Deployment namespace in kubernetes.                                                                    |
| environment-slug | no           | N/A                         | Short name of the deployment environment (dev, prod, etc). Set this if you have a `values-<env>.yaml`. |
| dry-run          | no           | false                       | Skip actual deployment and only show a diff.                                                           |


TODO notes:
- Make this a docker action so runners don't need helm etc installed
