## mount aws credentials
## api
docker build -t api .
docker run -d -it -p 8080:80 -v $HOME/.aws/:/app/.aws/:ro --restart always --name api api 

## frontend
docker build -t frontend .
docker run -d -p 8081:80 --restart always --name frontend frontend

## jenkins
docker run -d -it -p 1080:8080 -p 50000:50000 -v jenkins:/var/jenkins_home -v /var/run/docker.sock:/var/run/docker.sock --restart always jenkins/jenkins
docker exec <container_name> cat /var/jenkins_home/secrets/initialAdminPassword

## helm chart
https://medium.com/@mattiaperi/create-a-public-helm-chart-repository-with-github-pages-49b180dbb417

$ git clone <github-repo> && cd
# avoid bot crawling on my repository, so add robots.txt file
$ echo -e “User-Agent: *\nDisallow: /” > robots.txt

$ mkdir helm-chart-sources && cd ./helm-chart-sources/
$ helm create helm-chart-sources/helm-chart-test

# Lint the chart
$ helm lint helm-chart-sources/*

# Create the Helm chart package
$ helm package helm-chart-sources/*

# Create the Helm chart repository index
$ helm repo index --url <github-repo> .

# Push the git repository on GitHub
$ git add . && git commit -m “Initial commit” && git push origin master

# Configure helm client
$ helm repo add myhelmrepo https://mattiaperi.github.io/helm-chart/

