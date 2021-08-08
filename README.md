# turn-based-project
# mount aws credentials
# api
docker build -t api .
docker run -d -it -p 8080:80 -v $HOME/.aws/:/app/.aws/:ro --restart always --name api api 

# frontend
docker build -t frontend .
docker run -d -p 8081:80 --restart always --name frontend frontend