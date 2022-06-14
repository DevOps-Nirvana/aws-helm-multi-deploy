# Kubernetes Helm Multi-Deploy

This action will deploy all Helm chart folders inside a 'deployment' folder in your repository root. For example:

```
my-awesome-app/
├── README.md
├── deployment
│   ├── my-deployment-1
│   │   ├── Chart.yaml
│   │   ├── values-dev.yaml
│   │   ├── values-prod.yaml
│   │   └── values.yaml
│   └── my-deployment-2
│       ├── Chart.yaml
│       ├── values-dev.yaml
│       ├── values-prod.yaml
│       └── values.yaml
└── src
    └── etc
```

For the above file system, this action will deploy `my-deployment-1`, `my-deployment-2`, and any other charts under the deployment folder.

If you define the input `environment-slug`, then `values-<env>.yaml` will be applied **on top of** your `values.yml`. This is to provide the option of having different settings per environment.

## Inputs

| **Input**        | **Required** | **Default**                 | **Description**                                                                                        |
|------------------|--------------|-----------------------------|--------------------------------------------------------------------------------------------------------|
| image-tag        | yes          | N/A                         | Image tag to use in each deployment.                                                                   |
| k8s-namespace    | yes          | N/A                         | Deployment namespace in kubernetes.                                                                    |
| environment-slug | no           | N/A                         | Short name of the deployment environment (dev, prod, etc). Set this if you have a `values-<env>.yaml`. |
| dry-run          | no           | false                       | Skip actual deployment and only show a diff.                                                           |


TODO notes:
- Make this a docker action so runners don't need helm etc installed
