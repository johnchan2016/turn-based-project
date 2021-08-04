# turn-based-project
# api/dockerfile
docker build -t api .
docker run -d -p 8080:5000 --restart always --name api api
