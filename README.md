# TACACS+ Docker Image
# How to use
Build the image:
```
docker compose build --no-cache
```
Start the container:
```
docker compose up -d
```
# Tacacs+ configuration
### Users:
At this point, the configuration has 2 users.
1. user: netadm - pass: netadm@01
2. user: netusr - pass: netusr@01

The '**netadm**' user has full privileges, while the '**netusr**' user has only
viewing privileges
