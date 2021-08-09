# turn-based-project
# mount aws credentials
# api
docker build -t api .
docker run -d -it -p 8080:80 -v $HOME/.aws/:/app/.aws/:ro --restart always --name api api 

# frontend
docker build -t frontend .
docker run -d -p 8081:80 --restart always --name frontend frontend

# jenkins
docker run -p 8080:8080 -p 50000:50000 jenkins:2.60.3
docker exec <container_name> cat /var/jenkins_home/secrets/initialAdminPassword