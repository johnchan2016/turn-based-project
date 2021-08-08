# turn-based-project
# mount aws credentials
# api
docker build -t api .
docker run -d -p 8080:80 --restart always --name api api -v ${HOME}/.aws/credentials:/root/.aws/credentials:ro

# frontend
docker build -t frontend .
docker run -d -p 8081:80 --restart always --name frontend frontend