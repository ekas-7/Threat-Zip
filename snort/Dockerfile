FROM ubuntu:20.04

# Avoid interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    libdaq-dev \
    libdumbnet-dev \
    libluajit-5.1-dev \
    libpcap-dev \
    libpcre3-dev \
    libssl-dev \
    pkg-config \
    zlib1g-dev \
    wget \
    flex \
    bison \
    make \
    gcc \
    g++ \
    libtool \
    autotools-dev \
    libhwloc-dev \
    cmake \
    && rm -rf /var/lib/apt/lists/*

# Install Snort 2.9 (more stable for lab use)
WORKDIR /tmp
RUN wget https://www.snort.org/downloads/snort/snort-2.9.20.tar.gz \
    && tar -xzf snort-2.9.20.tar.gz \
    && cd snort-2.9.20 \
    && ./configure --enable-sourcefire \
    && make -j$(nproc) \
    && make install \
    && ldconfig

# Create directories
RUN mkdir -p /etc/snort/rules \
    && mkdir -p /var/log/snort \
    && mkdir -p /usr/local/lib/snort_dynamicrules \
    && mkdir -p /etc/snort/preproc_rules

# Create snort user
RUN groupadd snort && useradd -r -s /bin/false -g snort snort
RUN chown -R snort:snort /etc/snort /var/log/snort

# Copy configuration files
COPY config/snort.conf /etc/snort/snort.conf
COPY rules/*.rules /etc/snort/rules/

# Set proper permissions
RUN chmod 644 /etc/snort/snort.conf \
    && chmod 644 /etc/snort/rules/*.rules

# Default command
CMD ["snort", "-i", "eth0", "-A", "fast", "-c", "/etc/snort/snort.conf", "-l", "/var/log/snort"]
