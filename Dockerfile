# Use Base Ubuntu image
FROM ubuntu:18.04

LABEL Name=tac_plus
LABEL Version=1.0

# Author of this Dockerfile
LABEL maintainer="Luis Henrique Carneiro <luishenrique.carneiro@gmail.com>"

COPY tacacs-F4.0.4.28.tar.gz tacacs-F4.0.4.28.tar.gz

# Update & upgrades
RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y gcc make flex libwrap0-dev bison apt-utils openssh-server iputils-ping telnet iproute2 && \
    tar -xzf tacacs-F4.0.4.28.tar.gz && \
    cd tacacs-F4.0.4.28 && \
    ./configure --prefix=/tacacs && \
    make && \
    make install && \
    cd / && \
    rm -r tacacs-F4.0.4.28* && \
    useradd -m -d /home/netadm -s /bin/bash netadm && \
    useradd -m -d /home/netusr -s /bin/bash netusr && \
    echo "netadm:netadm@01" | chpasswd && \
    echo "netusr:netusr@01" | chpasswd && \
    echo 'KexAlgorithms diffie-hellman-group1-sha1,curve25519-sha256@libssh.org,ecdh-sha2-nistp256,ecdh-sha2-nistp384,ecdh-sha2-nistp521,diffie-hellman-group-exchange-sha256,diffie-hellman-group14-sha1,diffie-hellman-group-exchange-sha1' >> /etc/ssh/ssh_config && \
    echo 'PubkeyAcceptedAlgorithms +ssh-rsa' >> /etc/ssh/ssh_config && \
    echo 'HostkeyAlgorithms +ssh-rsa' >> /etc/ssh/ssh_config && \
    echo 'Ciphers aes256-ctr,aes128-cbc,3des-cbc,aes192-cbc,aes256-cbc' >> /etc/ssh/ssh_config && \
    echo 'MACs hmac-sha1,hmac-sha1-96,hmac-sha2-256,hmac-sha2-512,hmac-md5,hmac-md5-96,umac-64@openssh.com,umac-128@openssh.com,hmac-sha1-etm@openssh.com,hmac-sha1-96-etm@openssh.com,hmac-sha2-256-etm@openssh.com,hmac-sha2-512-etm@openssh.com,hmac-md5-etm@openssh.com,hmac-md5-96-etm@openssh.com,umac-64-etm@openssh.com,umac-128-etm@openssh.com' >> /etc/ssh/ssh_config

# Copy tac_plus configuration file from host to the container
COPY tacacs_sample.cfg /etc/tacacs+/tac_plus.conf

# Change owner to root
RUN chown root:root /etc/tacacs+/tac_plus.conf

# Change permission to root only access
RUN chmod 600 /etc/tacacs+/tac_plus.conf

RUN apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /var/cache/apt/*

ENTRYPOINT service ssh start && /tacacs/sbin/tac_plus -G -C /etc/tacacs+/tac_plus.conf
