FROM python:3.11-alpine3.19
ARG USERNAME=ansible
ARG USER_UID=1000
ARG USER_GID=1000
ARG ANSIBLE_VERSION=9.3.0
ARG SOPS_VERSION=3.8.1

RUN apk add --no-cache \
    openssh-client \
    bash \
    sudo \
    curl \
    gnupg

RUN curl -L https://github.com/mozilla/sops/releases/download/v${SOPS_VERSION}/sops-v${SOPS_VERSION}.linux.amd64 -o /usr/local/bin/sops && \
    chmod +x /usr/local/bin/sops

RUN pip3 install --no-cache-dir \
    ansible==${ANSIBLE_VERSION} \
    python-dateutil \
    requests

RUN addgroup -g ${USER_GID} ${USERNAME} \
    && adduser -u ${USER_UID} -G ${USERNAME} -D ${USERNAME} \
    && echo "${USERNAME} ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/${USERNAME} \
    && chmod 0440 /etc/sudoers.d/${USERNAME}

WORKDIR /ansible
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
RUN chown -R ${USERNAME}:${USERNAME} /ansible


USER ${USERNAME}
ENTRYPOINT ["/entrypoint.sh"]
CMD ["ansible-config", "dump"]
