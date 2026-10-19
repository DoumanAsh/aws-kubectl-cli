FROM docker.io/alpine:latest

# Reference:
# Check kubernetes-* tags
# https://github.com/kubernetes/kubectl/tags
ARG KUBECTL_VERSION=1.36.2
ENV HOME=/home/dev/
RUN set -eux; \
    adduser -D -u 10001 dev -G root -h $HOME -s /sbin/nologin ;\
    apk add --no-cache aws-cli ; \
    apkArch="$(apk --print-arch)"; \
    case "$apkArch" in \
        x86_64) kubectlArch='amd64' ;; \
        aarch64) kubectlArch='arm64' ;; \
        *) echo >&2 "unsupported architecture: '$apkArch'"; exit 1 ;; \
    esac; \
    wget -q https://dl.k8s.io/release/v${KUBECTL_VERSION}/bin/linux/${kubectlArch}/kubectl -O /usr/local/bin/kubectl ;\
    chmod +x /usr/local/bin/kubectl 

WORKDIR /home/dev/
USER dev
ENTRYPOINT ["/bin/sh"]
