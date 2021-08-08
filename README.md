# turn-based-project
# mount aws credentials
# api
docker build -t api . --build-arg HOME="/home"
docker run -d -p 8080:80 --restart always --name api api -v $HOME/.aws/:/home/.aws/:ro

# frontend
docker build -t frontend .
docker run -d -p 8081:80 --restart always --name frontend frontend