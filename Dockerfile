# Source: https://github.com/apptainer/singularity/blob/master/INSTALL.md

FROM ubuntu:22.04

ENV GOVERSION=1.20.3
ENV VERSION=3.9.9
ENV OS=linux
ENV ARCH=amd64
# supress Configuring keyboard-configuration
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ Europe/Berlin

WORKDIR /app

# Fix:
# FATAL:   container creation failed: mount /etc/localtime->/etc/localtime error: while mounting /etc/localtime: mount source /etc/localtime doesn't exist
# Source: https://serverfault.com/a/856593
RUN echo $TZ > /etc/timezone && \
apt-get update && apt-get install -y tzdata && \
rm /etc/localtime && \
ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && \
dpkg-reconfigure -f noninteractive tzdata

# Install dependencies ---------------------------------------------------------------

RUN apt-get install -y \
    build-essential \
    libseccomp-dev \
    pkg-config \
    squashfs-tools \
    cryptsetup \
    curl wget \
    git && rm -rf /var/lib/apt/lists/*

# Install Go ------------------------------------------------------------

RUN wget -O /tmp/go${GOVERSION}.${OS}-${ARCH}.tar.gz \
    https://dl.google.com/go/go${GOVERSION}.${OS}-${ARCH}.tar.gz

RUN tar -C /usr/local -xzf /tmp/go${GOVERSION}.${OS}-${ARCH}.tar.gz && rm /tmp/go${GOVERSION}.${OS}-${ARCH}.tar.gz

RUN echo 'export PATH=$PATH:/usr/local/go/bin' >> ~/.bashrc
#SHELL ["/bin/bash", "-c"]
#RUN source ~/.bashrc
ENV PATH=$PATH:/usr/local/go/bin

# Install Singularity ----------------------------------------------

# See Singularity releases: https://github.com/sylabs/singularity/releases
# > 3.7.3 following syntax
RUN wget https://github.com/sylabs/singularity/releases/download/v${VERSION}/singularity-ce-${VERSION}.tar.gz && \
  tar -xzf singularity-ce-${VERSION}.tar.gz && \
  mv singularity-ce-${VERSION} singularity && \
  rm singularity-ce-${VERSION}.tar.gz

# <= 3.7.3 following syntax
#export VERSION=3.7.3 && # adjust this as necessary \
#  wget https://github.com/sylabs/singularity/releases/download/v${VERSION}/singularity-${VERSION}.tar.gz &&
#  tar -xzf singularity-${VERSION}.tar.gz &&
#  rm singularity-${VERSION}.tar.gz
# cd singularity

# Compile
RUN cd singularity && \
  ./mconfig && \
  make -C ./builddir && \
  make -C ./builddir install

# Test singularity
RUN singularity --version

ENTRYPOINT ["singularity"]