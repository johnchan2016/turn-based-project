# Jenkins CI

1. mount aws credentials

2. create docker image 
  - api
  ```
  $ docker build -t api .
  $ docker run -d -it -p 8080:80 -v $HOME/.aws/:/app/.aws/:ro --restart always --name api api
  ```

  - frontend
  ```
  $ docker build -t frontend .
  $ docker run -d -p 8081:80 --restart always --name frontend frontend
  ```

3. Build Jenkins
  - run jenkins with privileged
  ```
  $ docker run -d -it -u 0 --privileged --name jenkins -p 1080:8080 -p 50000:50000 \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -v $(which docker):/usr/bin/docker \
    -v $HOME/jenkins_home:/var/jenkins_home \
    jenkins/jenkins
  ```


  - Get Jenkins initial Admin Password
  ```
  $ docker exec <container_name> cat /var/jenkins_home/secrets/initialAdminPassword
  ```

  - install neccessary jenkins plugins
    - Multibranch pipeline
    - Blue Ocean
    - Docker Pipeline

  - create credentials for github & dockerhub
    - github: a/c & personal access token (pw)
  
  - jenkins pipeline 
    - create a Dockerfile & set pipeline to run this file
    - set up stages
      - build docker image 
      - push image to docker hub
      - set up github page for helm repo, ref: https://medium.com/@mattiaperi/create-a-public-helm-chart-repository-with-github-pages-49b180dbb417

  - check if helm repo is successfully setup
  ```
  $ helm repo add <repo-name> <github-page-url>
  $ helm search repo <repo-name>
  ```

  <!-- chart version must be semantic -->
  <!-- appversion do not need to be semantic version -->
  - update helm chart repo
  ```
  $ helm repo update
  ```
