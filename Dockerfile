FROM public.ecr.aws/docker/library/alpine:latest

# Reference:
# https://docs.aws.amazon.com/eks/latest/userguide/install-kubectl.html#linux_amd64_kubectl
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
    wget -q https://s3.us-west-2.amazonaws.com/amazon-eks/${KUBECTL_VERSION}/2026-07-05/bin/linux/arm64/kubectl -O /usr/local/bin/kubectl ;\
    chmod +x /usr/local/bin/kubectl 

WORKDIR /home/dev/
USER dev
ENTRYPOINT ["/bin/sh"]
