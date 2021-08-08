# turn-based-project
# mount aws credentials
# api
docker build -t api .
docker run -d -it -v $HOME/.aws/:/app/.aws/:ro --name api api -p 8080:80 --restart always

# frontend
docker build -t frontend .
docker run -d -p 8081:80 --restart always --name frontend frontend