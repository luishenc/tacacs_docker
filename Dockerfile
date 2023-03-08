# Use Base Ubuntu image
FROM ubuntu:18.04 as intermediate

LABEL Name=tac_plus
LABEL Version=1.0

# Author of this Dockerfile
LABEL maintainer="Luis Henrique Carneiro <luishenrique.carneiro@gmail.com>"

COPY tacacs-F4.0.4.28.tar.gz tacacs-F4.0.4.28.tar.gz

# Update & upgrades
RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y gcc make flex bison libwrap0-dev && \
    tar -xzf tacacs-F4.0.4.28.tar.gz && \
    cd tacacs-F4.0.4.28 && \
    ./configure --prefix=/tacacs && \
    make && \
    make install && \
    cd / && \
    rm -r tacacs-F4.0.4.28*


FROM ubuntu:18.04

COPY --from=intermediate /tacacs /tacacs

RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y libwrap0-dev && \
    useradd -m -d /home/netadm -s /bin/bash netadm && \
    useradd -m -d /home/netusr -s /bin/bash netusr && \
    echo "netadm:netadm@01" | chpasswd && \
    echo "netusr:netusr@01" | chpasswd && \
    apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /var/cache/apt/*

# Copy tac_plus configuration file from host to the container
COPY tacacs_sample.cfg /etc/tacacs+/tac_plus.conf

# Change owner to root
RUN chown root:root /etc/tacacs+/tac_plus.conf

# Change permission to root only access
RUN chmod 600 /etc/tacacs+/tac_plus.conf

CMD ["/tacacs/sbin/tac_plus", "-G", "-C", "/etc/tacacs+/tac_plus.conf"]
