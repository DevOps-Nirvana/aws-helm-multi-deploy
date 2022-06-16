FROM ubuntu:20.04
ARG DEBIAN_FRONTEND=noninteractive

ARG HELM_VERSION=3.3.0
ARG HELMFILE_VERSION=0.119.1

ENV HELM_DATA_HOME=/usr/local/share/helm

# Install everything under a single run to minimize disk space of final image
RUN  apt update -y \
  && apt install -y \
    python3-dev \
    git \
    curl \
    unzip

  # Install Kubectl/kubectx/kubens
  RUN curl -sL -o /usr/local/bin/kubectl https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl \
  && curl -sL -o /usr/local/bin/kubectx https://github.com/ahmetb/kubectx/releases/download/v0.9.4/kubectx \
  && curl -sL -o /usr/local/bin/kubens https://github.com/ahmetb/kubectx/releases/download/v0.9.4/kubens \
  && chmod a+x /usr/local/bin/kube* \
  && kubectl version || true \

  # Install helm and helmfile and plugins
  # Install Go temporarily for compiling helm plugins
  # Remove go
  && curl -sL https://get.helm.sh/helm-v${HELM_VERSION}-linux-amd64.tar.gz > /tmp/helm-v${HELM_VERSION}-linux-amd64.tar.gz \
  && cd /tmp && tar --strip-components=1 -xf helm-v${HELM_VERSION}-linux-amd64.tar.gz && chmod a+x helm && mv helm /usr/local/bin/ && helm version \
  && apt-get install -y golang \
  && helm plugin install https://github.com/hypnoglow/helm-s3.git --version master \
  && helm plugin install https://github.com/databus23/helm-diff --version master \
  && helm s3 --help && helm diff --help \
  && apt-get remove golang -y \
  && curl -sL -o /usr/local/bin/helmfile https://github.com/roboll/helmfile/releases/download/v${HELMFILE_VERSION}/helmfile_linux_amd64 \
  && chmod a+x /usr/local/bin/helmfile \

  # Install AWS CLI 2.0
  && cd /tmp \
  && curl -sL "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" \
  && unzip awscliv2.zip \
  && ./aws/install \
  && rm -Rf ./aws* \
  && aws --version \

  # Cleanup
  && apt-get autoremove -y \
  && rm -rf /var/lib/apt/lists/* \

  # Pre-setup kubectl to work from within the cluster, without this helm and kubectx/kubens freaks out about "no contexts defined"
  && kubectl config set-context local-kubernetes-cluster \
  && kubectl config use-context local-kubernetes-cluster

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
