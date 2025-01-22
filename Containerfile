FROM quay.io/kairos/rockylinux:9-standard-amd64-generic-v3.2.4-k3sv1.31.3-k3s1

ARG KC_VERSION

# Enable NTP
RUN dnf install -y chrony &&\
    systemctl enable chronyd

# Install Tailscale
RUN dnf install -y 'dnf-command(config-manager)' &&\
    dnf config-manager --add-repo https://pkgs.tailscale.com/stable/rhel/9/tailscale.repo &&\
    dnf install tailscale-1.78.1 -y &&\
    systemctl enable tailscaled

# Add a unit file that runs before k3s is started
COPY systemd-units/k3s-before.service /etc/systemd/system/k3s-before.service
RUN systemctl enable k3s-before.service

# Add a unit file that runs before k3s-agent is started
COPY systemd-units/k3s-agent-before.service /etc/systemd/system/k3s-agent-before.service
RUN systemctl enable k3s-agent-before.service

# Add our own variables to /etc/os-release
RUN sed -i -n '/CONDUIT_/!p' /etc/os-release &&\
    echo CONDUIT_VERSION=${KC_VERSION} >> /etc/os-release
