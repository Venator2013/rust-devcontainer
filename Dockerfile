FROM docker.io/library/ubuntu:kinetic

SHELL ["/bin/bash", "-c"]

USER 0

# Copy configuration files to appropriate locations
#COPY files /

# Install packages from apt repositories
ARG DEBIAN_FRONTEND="noninteractive"
# Ignore other repositories here, as some require HTTPS
RUN apt-get update --quiet --option Dir::Etc::SourceParts="" && \
  # Install packages from official repository or mirror
  apt-get install --yes --quiet --option Dir::Etc::SourceParts="" \
  apt-transport-https \
  bash \
  ca-certificates \
  curl \
  wget \
  make \
  build-essential \
  gcc \
  git \
  vim \
  nano \
  locales && \
  # Delete package cache to avoid consuming space in layer
  curl -fsSL https://code-server.dev/install.sh | sh && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/*

# Add a user `coder` so that you're not developing as the `root` user
RUN useradd coder \
  --create-home \
  --shell=/bin/bash \
  --uid=1000 \
  --user-group

RUN curl -fsSL https://gitlab.com/8Bitz0/coder-rust-template/-/raw/main/resources/bashrc > /home/coder/.bashrc && \
  chown coder /home/coder/.bashrc

USER 1000

# Install Rust using Rustup
RUN curl https://sh.rustup.rs -sSf | sh -s -- -y
