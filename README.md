# TACACS+ Docker Image
# How to use
To run with the default configuration:
```
docker run --name tac_plus -d luishenc/tacacs_docker:latest
```
This image has ssh service enabled, to ssh into docker and use it as a jump server run the command below to get de ip address:
```
docker inspect --format='{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' tac_plus
```
