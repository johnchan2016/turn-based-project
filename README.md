# turn-based-project
# api
docker build -t api .
docker run -d -p 8080:80 --restart always --name api api


# frontend
docker build -t frontend .
docker run -d -p 8081:80 --restart always --name frontend frontend