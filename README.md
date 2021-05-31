# TACACS+ and SSH Server Docker Image
# How to use
I alread have ssh server running localy, so to access both I mapped port 22 from the container to port 2222 localy and keep tacacs server port as default:
```
docker run --name tac_plus -d -p 2222:22 -p 49:49 luishenc/tacacs_docker:latest
```
This image also has ssh service enabled, to ssh into docker and use it as a jump server run the command below to get de ip address:
```
docker inspect --format='{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' tac_plus
```
If you use the host ip to ssh into the container, run the below command:
```
ssh -l netadm -p 2222 localhost
```
