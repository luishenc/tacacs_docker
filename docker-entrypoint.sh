#!/bin/sh

TAC_PLUS_BIN=/tacacs/sbin/tac_plus
CONF_FILE=/etc/tacacs+/tac_plus.conf

# Make the log directories
mkdir -p /var/log/tac_plus.log

echo "Starting server..."

# Start tacacs server and sshd 
exec ${TAC_PLUS_BIN} -G -C ${CONF_FILE} && service ssh start
