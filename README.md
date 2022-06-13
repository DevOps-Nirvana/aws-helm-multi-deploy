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
| environment-slug | no           | N/A                         | Short name of the deployment environment (dev, prod, etc). Set this if you have a 'values-<env>.yaml'. |
| k8s-namespace    | no           | value of `environment-slug` | Deployment namespace in kubernetes.                                                                    |
| dry-run          | no           | false                       | Skip actual deployment and only show a diff.                                                           |


TODO notes:
- requires helm etc to be installed on the runner
- Make this a docker action so runners don't need helm etc installed
