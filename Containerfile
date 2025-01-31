ARG KAIROS_FLAVOR=k3sv1.32.0-k3s1
FROM quay.io/kairos/ubuntu:24.04-standard-amd64-generic-v3.3.0-${KAIROS_FLAVOR}

ARG KC_VERSION

# Install Tailscale
RUN curl -fsSL https://pkgs.tailscale.com/stable/ubuntu/noble.noarmor.gpg |\
        tee /usr/share/keyrings/tailscale-archive-keyring.gpg >/dev/null &&\
    curl -fsSL https://pkgs.tailscale.com/stable/ubuntu/noble.tailscale-keyring.list |\
        tee /etc/apt/sources.list.d/tailscale.list &&\
    apt-get update &&\
    apt-get install -y tailscale=1.78.1

# Add a unit file that runs before k3s is started
COPY systemd-units/k3s-before.service /etc/systemd/system/k3s-before.service
RUN systemctl enable k3s-before.service

# Add a unit file that runs before k3s-agent is started
COPY systemd-units/k3s-agent-before.service /etc/systemd/system/k3s-agent-before.service
RUN systemctl enable k3s-agent-before.service

# Add our own variables to /etc/os-release
RUN sed -i -n '/CONDUIT_/!p' /etc/os-release &&\
    echo CONDUIT_VERSION=${KC_VERSION} >> /etc/os-release
