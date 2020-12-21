# See here for image contents: https://github.com/microsoft/vscode-dev-containers/tree/v0.154.0/containers/dotnet/.devcontainer/base.Dockerfile

# [Choice] .NET version: 5.0, 3.1, 2.1
ARG VARIANT="5.0"
FROM mcr.microsoft.com/vscode/devcontainers/dotnetcore:0-${VARIANT}

# [Option] Install Node.js
ARG INSTALL_NODE="false"
ARG NODE_VERSION="lts/*"
RUN if [ "${INSTALL_NODE}" = "true" ]; then su vscode -c "source /usr/local/share/nvm/nvm.sh && nvm install ${NODE_VERSION} 2>&1"; fi

# [Option] Install Azure CLI
ARG INSTALL_AZURE_CLI="false"
COPY library-scripts/azcli-debian.sh /tmp/library-scripts/
RUN if [ "$INSTALL_AZURE_CLI" = "true" ]; then bash /tmp/library-scripts/azcli-debian.sh; fi \
    && apt-get clean -y && rm -rf /var/lib/apt/lists/* /tmp/library-scripts

# [Option] Install Terraform
ARG INSTALL_TERRAFORM="false"
COPY library-scripts/terraform-debian.sh /tmp/library-scripts/
RUN if [ "$INSTALL_TERRAFORM" = "true" ]; then bash /tmp/library-scripts/terraform-debian.sh; fi \
    && apt-get clean -y && rm -rf /var/lib/apt/lists/* /tmp/library-scripts

# [Option] Install Kubectl Helm
ARG INSTALL_KUBECTL_HELM="false"
COPY library-scripts/kubectl-helm-debian.sh /tmp/library-scripts/
RUN if [ "$INSTALL_KUBECTL_HELM" = "true" ]; then bash /tmp/library-scripts/kubectl-helm-debian.sh; fi \
    && apt-get clean -y && rm -rf /var/lib/apt/lists/* /tmp/library-scripts

# [Option] Install Docker and Docker-compose
ARG INSTALL_DOCKER="false"
COPY library-scripts/docker-debian.sh /tmp/library-scripts/
RUN if [ "$INSTALL_DOCKER" = "true" ]; then bash /tmp/library-scripts/docker-debian.sh; fi \
    && apt-get clean -y && rm -rf /var/lib/apt/lists/* /tmp/library-scripts


# [Optional] Uncomment this line to install global node packages.
# RUN su vscode -c "source /usr/local/share/nvm/nvm.sh && npm install -g <your-package-here>" 2>&1