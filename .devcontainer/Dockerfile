# Use an official Debian base image
FROM debian:bullseye-slim

# Set the DEBIAN_FRONTEND to noninteractive to suppress prompts
ENV DEBIAN_FRONTEND=noninteractive

# Install apt-utils first to prevent warnings
RUN apt-get update && apt-get install -y --no-install-recommends apt-utils && rm -rf /var/lib/apt/lists/*

# Install dependencies directly
RUN apt-get update && \
    apt-get install -y \
    curl \
    unzip \
    gnupg \
    lsb-release \
    git \
    sudo \
    bash-completion \
    jq \
    vim \
    nano \
    ansible \
    && rm -rf /var/lib/apt/lists/*

# Install yq for YAML processing
RUN curl -L https://github.com/mikefarah/yq/releases/download/v4.15.1/yq_linux_amd64 -o /usr/local/bin/yq \
    && chmod +x /usr/local/bin/yq

# Install Mozilla SOPS
RUN curl -L https://github.com/mozilla/sops/releases/download/v3.7.3/sops-v3.7.3.linux.amd64 -o /usr/local/bin/sops \
    && chmod +x /usr/local/bin/sops

# Install HashiCorp Packer and Terraform
RUN curl -fsSL https://apt.releases.hashicorp.com/gpg | gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg && \
    echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/hashicorp.list > /dev/null && \
    apt-get update && \
    apt-get install -y packer terraform && \
    rm -rf /var/lib/apt/lists/*

# Install AWS CLI
RUN curl -fsSL "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "/tmp/awscliv2.zip" && \
    unzip /tmp/awscliv2.zip -d /tmp && \
    /tmp/aws/install && \
    rm -rf /tmp/aws /tmp/awscliv2.zip

# Install pre-commit
RUN apt-get update && apt-get install -y python3-pip && \
    pip3 install --no-cache-dir pre-commit && \
    rm -rf /var/lib/apt/lists/*

# Set up a non-root user for VSCode (user "vscode" is commonly used for containers)
RUN useradd -m vscode && \
    echo "vscode ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/vscode && \
    chmod 0440 /etc/sudoers.d/vscode && \
    chsh -s /bin/bash vscode

# Set working directory to /buildworkspace and give the vscode user permissions
WORKDIR /buildworkspace
RUN chown -R vscode:vscode /buildworkspace

# Switch to the vscode user for container runtime
USER vscode

# Default shell setup
SHELL ["/bin/bash", "-c"]
