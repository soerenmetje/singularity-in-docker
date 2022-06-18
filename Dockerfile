# Source: https://github.com/apptainer/singularity/blob/master/INSTALL.md

FROM ubuntu:22.04

ENV GOVERSION=1.17.3
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
RUN cd /usr/local && git clone https://github.com/hpcng/singularity.git && cd ./singularity && ./mconfig && cd ./builddir && make && make install

# Test singularity
RUN singularity --version

ENTRYPOINT ["singularity"]