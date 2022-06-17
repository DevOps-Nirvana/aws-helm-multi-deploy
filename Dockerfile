FROM alpine:edge

ENV HELM_DATA_HOME=/usr/local/share/helm

RUN echo "https://dl-cdn.alpinelinux.org/alpine/edge/testing/" >> /etc/apk/repositories

RUN apk add --no-cache bash openssl git curl aws-cli helm

# Install kubectl
RUN curl -sL -o /usr/bin/kubectl https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl && \
    chmod +x /usr/bin/kubectl

# Install helm and plugins
RUN curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 > get_helm.sh && \
  chmod 700 get_helm.sh && \
  ./get_helm.sh
RUN helm plugin install https://github.com/databus23/helm-diff

# Install AWS CLI 2.0
RUN cd /tmp \
  && curl -sL "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" \
  && unzip awscliv2.zip \
  && ./aws/install \
  && rm -Rf ./aws* \
  && aws --version

RUN apk del --no-cache openssl curl git

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
