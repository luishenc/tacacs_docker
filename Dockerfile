# Use Base Ubuntu image
FROM ubuntu:18.04

LABEL Name=tac_plus
LABEL Version=1.0

# Author of this Dockerfile
LABEL maintainer="Luis Henrique Carneiro <luishenrique.carneiro@gmail.com>"

ADD https://github.com/luishenc/tacacs_docker/raw/main/tacacs-F4.0.4.28.tar.gz tacacs-F4.0.4.28.tar.gz

# Update & upgrades
RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y gcc make flex libwrap0-dev bison apt-utils && \
    tar -xzf tacacs-F4.0.4.28.tar.gz && \
    cd tacacs-F4.0.4.28 && \
    ./configure --prefix=/tacacs && \
    make && \
    make install

# Clear local repo
RUN apt-get clean

# Create a user with home directory. This user will be used for Admin access
RUN useradd -m -d /home/netadm -s /bin/bash netadm

# Create a user with home directory. This user will be used for View access
RUN useradd -m -d /home/netusr -s /bin/bash netusr

# Add password to netadm account
RUN echo "netadm:netadm@01" | chpasswd

# Add password to netusr account
RUN echo "netusr:netusr@01" | chpasswd

# Copy tac_plus configuration file from host to the container
COPY tacacs_sample.cfg /etc/tacacs+/tac_plus.conf

# Change owner to root
RUN chown root:root /etc/tacacs+/tac_plus.conf

# Change permission to root only access
RUN chmod 600 /etc/tacacs+/tac_plus.conf

RUN apt-get update && \
    rm -rf /var/cache/apt/*

# Run tac_plus as foreground process and use /etc/tacacas+/tac_plus.conf as the config file
CMD ["/tacacs/sbin/tac_plus", "-G", "-C", "/etc/tacacs+/tac_plus.conf"]

