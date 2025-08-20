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
    && rm -rf /var/lib/apt/lists/*

# Download and install Snort 3
WORKDIR /tmp
RUN wget https://github.com/snort3/snort3/archive/refs/tags/3.1.45.0.tar.gz \
    && tar -xzf 3.1.45.0.tar.gz \
    && cd snort3-3.1.45.0 \
    && ./configure_cmake.sh --prefix=/usr/local \
    && cd build \
    && make -j$(nproc) \
    && make install \
    && ldconfig

# Create directories
RUN mkdir -p /etc/snort/rules \
    && mkdir -p /var/log/snort \
    && mkdir -p /usr/local/lib/snort_dynamicrules

# Copy configuration files
COPY config/snort.conf /etc/snort/snort.conf
COPY rules/*.rules /etc/snort/rules/

# Create snort user
RUN groupadd snort && useradd -r -s /bin/false -g snort snort
RUN chown -R snort:snort /etc/snort /var/log/snort

# Expose the interface
EXPOSE 161/udp

# Default command
CMD ["snort", "-i", "eth0", "-A", "console", "-c", "/etc/snort/snort.conf", "-l", "/var/log/snort"]
