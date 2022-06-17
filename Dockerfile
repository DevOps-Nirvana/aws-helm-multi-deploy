FROM amazon/aws-cli

ENV HELM_DATA_HOME=/usr/local/share/helm


RUN yum install -y openssl tar gzip git

# Install kubectl
RUN curl -sL -o /usr/bin/kubectl https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl && \
    chmod +x /usr/bin/kubectl

# Install helm and plugins
RUN curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 > get_helm.sh && \
  chmod 700 get_helm.sh && \
  ./get_helm.sh
RUN helm plugin install https://github.com/databus23/helm-diff


COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
