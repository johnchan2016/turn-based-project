# turn-based-project
# api/dockerfile
docker build -t api .
docker run -d -p 8080:80 --restart always --name api api
