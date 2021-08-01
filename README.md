# turn-based-project
# api/dockerfile
docker build -t api .
docker run -d --restart --name api api