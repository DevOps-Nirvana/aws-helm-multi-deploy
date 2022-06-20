# Kubernetes Helm Multi-Deploy

> :warning: **This action's docker image is built at runtime.**
>
> For a pre-built docker-based action with all dependencies included [see here](https://github.com/DevOps-Nirvana/aws-helm-multi-deploy-prebuilt)
>
> For a no-docker action which requies all dependencies be installed in the GitHub Docker [see here](https://github.com/DevOps-Nirvana/aws-helm-multi-deploy-nodocker)

This GitHub Action will deploy all Helm chart folders inside a 'deployment' folder in your repository root. Useful for deploying multiple services that are in separate charts. For example:

```
my-awesome-app/
├── README.md
├── deployment
│   ├── my-deployment-1
│   │   ├── Chart.yaml
|   |   ├── requirements.yaml
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

For the above file system, this action will deploy `my-deployment-1`, `my-deployment-2`, and any other charts under the deployment folder. Each chart can contain subcharts too.

If you define the input `environment-slug`, then `values-<env>.yaml` will be applied **on top of** your `values.yml`. e.g. if you define `environment-slug=dev`, then the options `-f values.yaml -f values-dev.yaml` will be passed to helm (if `values-dev.yaml` exists). This is to provide the option of having different settings per environment.

## Inputs

| **Input**             | **Required** | **Default** | **Description**                                                                                        |
|-----------------------|--------------|-------------|--------------------------------------------------------------------------------------------------------|
| aws-access-key-id     | yes          | N/A         | AWS access key for the cluster                                                                         |
| aws-secret-access-key | yes          | N/A         | AWS secret key for the cluster                                                                         |
| aws-region            | no           | us-east-1   | AWS region for the cluster                                                                             |
| cluster-name          | yes          | N/A         | Cluster name in EKS                                                                                    |
| image-tag             | yes          | N/A         | Image tag to use in each deployment.                                                                   |
| k8s-namespace         | yes          | N/A         | Deployment namespace in kubernetes.                                                                    |
| environment-slug      | no           | N/A         | Short name of the deployment environment (dev, prod, etc). Set this if you have a `values-<env>.yaml`. |
| dry-run               | no           | false       | Skip actual deployment and only show a diff.                                                           |

## Example Usage

```yaml
jobs:
  build:
    steps:
      - uses: actions/checkout@v3
      - uses: docker/build-push-action@v3
          ...

  deploy:
    needs: build
    steps:
      - uses: actions/checkout@v2
      - uses: DevOps-Nirvana/k8s-helm-multi-deploy@v1
        with:
          aws-access-key-id: ${{ secrets.AWS_ACCESS_KEY_ID }}
          aws-secret-access-key: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
          aws-region: ${{ secrets.AWS_DEFAULT_REGION }}
          cluster-name: primary
          environment-slug: dev
          k8s-namespace: my-dev-ns
          image-tag: my-dev-image-tag
```
