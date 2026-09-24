# DinD Feature is defined in devcontainer.json. This Dockerfile installs
# all other tools not available as Features.
# ZSH + oh-my-zsh are included in the base image.
# Check: https://mcr.microsoft.com/v2/devcontainers/base/manifests/debian
FROM mcr.microsoft.com/devcontainers/base@sha256:1f851004adcd3dff3776b4a1da86727cf52280b0fdc9d5b0568c9c7d74274286

ARG DEBIAN_FRONTEND=noninteractive

# Set ZSH as login shell so VS Code terminals use it by default.
RUN chsh -s /bin/zsh vscode

# Writable git config directory for container-level settings.
# Identity is rendered from SOPS config by 'task bootstrap', never baked into the image.
RUN mkdir -p /home/vscode/.config/git && \
    printf '[safe]\n\tdirectory = /workspace\n[diff "sopsdiffer"]\n\ttextconv = sops -d\n' > /home/vscode/.config/git/config && \
    chown -R vscode:vscode /home/vscode/.config

# ── Versions ────────────────────────────────────────────────────────────────
ARG BOTO3_VERSION=1.43.95
ARG TASK_VERSION=3.53.1
ARG ANSIBLE_LINT_VERSION=26.8.0
ARG ANSIBLE_VERSION=14.4.0
ARG AWS_CLI_VERSION=2.36.46
ARG MARKDOWNLINT_CLI2_VERSION=0.23.2
ARG MKDOCS_MATERIAL_VERSION=9.7.7
ARG MKDOCS_VERSION=1.6.1
ARG NODEJS_VERSION=24.21.0
ARG OPENCODE_VERSION=1.18.31
ARG PACKER_VERSION=1.16.0
ARG PRE_COMMIT_VERSION=4.6.2
ARG PRETTIER_VERSION=3.9.6
ARG SHELLCHECK_VERSION=0.11.0
ARG SHFMT_VERSION=3.14.1
ARG SOPS_VERSION=3.13.3
ARG TERRAFORM_VERSION=1.16.2
ARG TFLINT_VERSION=0.64.0
ARG YAMLLINT_VERSION=1.38.0
ARG YQ_VERSION=4.53.6

# ── System packages ──────────────────────────────────────────────────────────
RUN apt-get update && apt-get install -y python3-venv && rm -rf /var/lib/apt/lists/*

# ── Python venv packages ─────────────────────────────────────────────────────
RUN python3 -m venv /usr/local/venv && \
    /usr/local/venv/bin/pip install \
    ansible==${ANSIBLE_VERSION} \
    ansible-lint==${ANSIBLE_LINT_VERSION} \
    boto3==${BOTO3_VERSION} \
    mkdocs==${MKDOCS_VERSION} \
    mkdocs-material==${MKDOCS_MATERIAL_VERSION} \
    pre-commit==${PRE_COMMIT_VERSION} \
    yamllint==${YAMLLINT_VERSION}

ENV PATH=/usr/local/venv/bin:$PATH

# ── Node.js ────────────────────────────────────────────────────────────────
# Check: https://nodejs.org/en/download
RUN curl -L -o /tmp/nodejs.tar.gz \
    "https://nodejs.org/dist/v${NODEJS_VERSION}/node-v${NODEJS_VERSION}-linux-x64.tar.gz" \
    && tar xz -C /usr/local -f /tmp/nodejs.tar.gz --strip-components=1 \
    && rm /tmp/nodejs.tar.gz

# ── npm global packages ────────────────────────────────────────────────────
# Check: https://www.npmjs.com/package/markdownlint-cli2, https://www.npmjs.com/package/prettier
RUN npm install -g \
    markdownlint-cli2@${MARKDOWNLINT_CLI2_VERSION} \
    prettier@${PRETTIER_VERSION}

# ── Task ─────────────────────────────────────────────────────────────────────
# Check: https://github.com/go-task/task/releases
RUN curl -L -o /tmp/task.tar.gz \
    "https://github.com/go-task/task/releases/download/v${TASK_VERSION}/task_linux_amd64.tar.gz" \
    && tar xz -C /usr/local/bin -f /tmp/task.tar.gz task \
    && rm /tmp/task.tar.gz

# ── AWS CLI ────────────────────────────────────────────────────────────────
# Installed in Dockerfile to avoid the AWS Toolkit extension that the Feature adds.
# Check: https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html
RUN curl -L -o /tmp/awscliv2.zip \
    "https://awscli.amazonaws.com/awscli-exe-linux-x86_64-${AWS_CLI_VERSION}.zip" \
    && unzip -o -q /tmp/awscliv2.zip -d /tmp \
    && /tmp/aws/install --install-dir /usr/local/aws-cli --bin-dir /usr/local/bin \
    && rm -rf /tmp/awscliv2.zip /tmp/aws

# ── OpenCode ────────────────────────────────────────────────────────────────
# Check: https://github.com/anomalyco/opencode/releases
RUN curl -L -o /tmp/opencode.tar.gz \
    "https://github.com/anomalyco/opencode/releases/download/v${OPENCODE_VERSION}/opencode-linux-x64.tar.gz" \
    && tar xz -C /usr/local/bin -f /tmp/opencode.tar.gz opencode \
    && chmod +x /usr/local/bin/opencode \
    && rm /tmp/opencode.tar.gz

# ── Packer ──────────────────────────────────────────────────────────────────
# Check: https://releases.hashicorp.com/packer/
RUN curl -L -o /tmp/packer.zip \
    "https://releases.hashicorp.com/packer/${PACKER_VERSION}/packer_${PACKER_VERSION}_linux_amd64.zip" \
    && unzip -o -q /tmp/packer.zip -d /usr/local/bin \
    && rm /tmp/packer.zip

# ── SOPS ────────────────────────────────────────────────────────────────────
# Check: https://github.com/getsops/sops/releases
RUN curl -Lo /usr/local/bin/sops \
    "https://github.com/getsops/sops/releases/download/v${SOPS_VERSION}/sops-v${SOPS_VERSION}.linux.amd64" \
    && chmod +x /usr/local/bin/sops

# ── Terraform ────────────────────────────────────────────────────────────────
# Check: https://releases.hashicorp.com/terraform/
RUN curl -L -o /tmp/terraform.zip \
    "https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip" \
    && unzip -o -q /tmp/terraform.zip -d /usr/local/bin \
    && rm /tmp/terraform.zip

# ── shellcheck ──────────────────────────────────────────────────────────────
# Check: https://github.com/koalaman/shellcheck/releases
RUN curl -L -o /tmp/shellcheck.tar.xz \
    "https://github.com/koalaman/shellcheck/releases/download/v${SHELLCHECK_VERSION}/shellcheck-v${SHELLCHECK_VERSION}.linux.x86_64.tar.xz" \
    && tar -xJ -C /tmp -f /tmp/shellcheck.tar.xz \
    && mv "/tmp/shellcheck-v${SHELLCHECK_VERSION}/shellcheck" /usr/local/bin/shellcheck \
    && rm -rf /tmp/shellcheck.tar.xz "/tmp/shellcheck-v${SHELLCHECK_VERSION}"

# ── shfmt ────────────────────────────────────────────────────────────────────
# Check: https://github.com/mvdan/sh/releases
RUN curl -Lo /usr/local/bin/shfmt \
    "https://github.com/mvdan/sh/releases/download/v${SHFMT_VERSION}/shfmt_v${SHFMT_VERSION}_linux_amd64" \
    && chmod +x /usr/local/bin/shfmt

# ── tflint ───────────────────────────────────────────────────────────────────
# Check: https://github.com/terraform-linters/tflint/releases
RUN curl -L -o /tmp/tflint.zip \
    "https://github.com/terraform-linters/tflint/releases/download/v${TFLINT_VERSION}/tflint_linux_amd64.zip" \
    && unzip -o -q /tmp/tflint.zip -d /usr/local/bin \
    && rm /tmp/tflint.zip

# ── yq ──────────────────────────────────────────────────────────────────────
# Standardized over jq.
# Check: https://github.com/mikefarah/yq/releases
RUN curl -Lo /usr/local/bin/yq \
    "https://github.com/mikefarah/yq/releases/download/v${YQ_VERSION}/yq_linux_amd64" \
    && chmod +x /usr/local/bin/yq
