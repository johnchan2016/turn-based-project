pipeline {
    /*
  environment {
    registry = "myhk2009/whale"
    githubCredential = 'dockerHubCredentials'
    dockerImage = ""

    REGION="hk"
    CODE_ENVFILE="env.groovy"
    HELM_ENVFILE="env.properties"
  }
  */
    environment {
        ImageName = 'myhk2009/turn-based-api';
        DockerHubCredential = 'dockerHubCredential';
        GithubCredential = 'githubCredential';

        CurrentTimestamp = GetTimestamp();
        CurrentEnv = GetEnvByBranch(env.BRANCH_NAME)
        IMAGE_TAG = "$CurrentEnv-$CurrentTimestamp";
        HELM_VALUE_FILE = GetHelmValueFile(CurrentEnv);
        HELM_VALUE_PATH = "backend-charts/api/$HELM_VALUE_FILE";
    }

    agent {
        dockerfile true 
    }

    stages {
        // get rolling number from env
        // build & push image to docker hub
        // update tag in values.yaml
        // update config & push to github
        /*
        stage('Set Configs') {
            steps {
                script {
                    sh 'printenv | sort'                    
                }

                echo 'Current BRANCH_NAME: ' + BRANCH_NAME;
                echo 'currentEnv: ' + CurrentEnv;
                echo 'currentTimestamp: ' + CurrentTimestamp;
            }
        }

        stage('Building image') {
            steps{
                script {
                    sh 'cd Api'
                    sh 'ls'
                    dockerImage = docker.build(env.ImageName + ':' + env.CurrentEnv + '-' + env.CurrentTimestamp, './Api')
                }
            }
        }

        stage('Deploy Image') {
            steps{
                script {
                    docker.withRegistry( 'https://registry.hub.docker.com', DockerHubCredential ) {
                        dockerImage.push()
                    }
                }
            }
        }

        stage('update tag in values.yaml'){
            steps {
                script {
                    sh "chmod +x -R ${env.WORKSPACE}"
                    sh './scripts/update-yaml-values.sh';
                }
            }
        }
        

        stage('package-helm-chart') {
            steps {
                dir("turn-based-api-chart") {
                    deleteDir()
                }

                withCredentials([usernamePassword(credentialsId: githubCredential, passwordVariable: 'GIT_PASSWORD', usernameVariable: 'GIT_USERNAME')]) {
                    script {
                        // remove all values*.yaml & rename new.yaml to values.yaml
                        sh './scripts/remove-unused-value-files.sh';

                        env.encodedUser=URLEncoder.encode(GIT_USERNAME, "UTF-8")
                        env.encodedPass=URLEncoder.encode(GIT_PASSWORD, "UTF-8")

                        sh 'helm package turn-based-api-chart'
                        sh 'helm repo index --url https://github.com/johnchan2016/turn-based-helm-chart.git .'

                        sh "echo '***** get content of index.yaml *****'"
                        sh 'cat index.yaml'
                        sh 'git add .'
                        sh 'git commit -m "create helm chart for version $IMAGE_TAG"'
                        sh 'git push https://${encodedUser}:${encodedPass}@github.com/johnchan2016/turn-based-helm-chart.git'
                    }
                }
            }
        }
        */

        stage('clone & update helm project'){
            steps{
                sh 'ls'
                sh "chmod +x -R ${env.WORKSPACE}"
                sh './scripts/remove-helm-chart-folder.sh';

                sh 'git clone https://github.com/johnchan2016/turn-based-helm-chart.git'
                sh 'cp -r backend-charts/* turn-based-helm-chart'
                sh 'cd turn-based-helm-chart'
                sh 'git remote add helm-origin https://github.com/johnchan2016/turn-based-helm-chart.git'
                echo '***** git remote *****'
                sh 'git fetch helm-origin'
                sh 'git branch -a'
                sh 'git remote -v'
                echo '***** *****'      

                /*
                withCredentials([usernamePassword(credentialsId: githubCredential, passwordVariable: 'GIT_PASSWORD', usernameVariable: 'GIT_USERNAME')]) {
                    script{
                        def encodedUser=URLEncoder.encode(GIT_USERNAME, "UTF-8")
                        def encodedPass=URLEncoder.encode(GIT_PASSWORD, "UTF-8")

                        sh 'git config --global user.name "johnchan"'
                        sh 'git config --global user.email myhk2009@gmail.com'

                        sh 'helm package turn-based-helm-chart/api --app-version $IMAGE_TAG'
                        sh 'helm repo index --url https://github.com/johnchan2016/turn-based-helm-chart.git .'

                        sh "echo '***** get content of index.yaml *****'"
                        sh 'cat index.yaml'
                        sh "echo '***** *****'"               
                        sh 'git add .'
                        sh 'git commit -m "create turn-based helm chart for version $IMAGE_TAG"'
                        sh 'git push https://' + encodedUser+ ':' + encodedPass + '@github.com/johnchan2016/turn-based-helm-chart.git origin master'
                    }
                }
                */
            }
        }
    }
}

def GetEnvByBranch(branchName){
    println "Current branchName: " + branchName;
    
    if (branchName == '') {
        return '';
    }

    if (branchName ==~ /^(feature)\/[\w-]+(:\d+\.\d+\.\d+){0}$/) {
        return 'dev';
    } else if  (branchName ==~ /^(release)\/[\w-]+(:\d+\.\d+\.\d+){0}$/) {
        return 'uat';
    } else if (branchName ==~ /^(release)\/[\w-]+(:\d+\.\d+\.\d+)$/) {
        return 'prod';
    } else {
        return '';
    }
}

def GetTimestamp(){
    def now = new Date();
    def currentTimeStamp = now.format("yyyyMMddhhmm");
    echo "Current Timestamp: " + currentTimeStamp;

    return currentTimeStamp; 
}

def GetHelmValueFile(env){
    if (env == 'dev') {
        return 'backend-charts/api/values.yaml';
    } else if (env == 'uat' || env == 'prod'){
        return "backend-charts/api/values_$CurrentHelmPath.yaml"
    } else {
        return '';
    }
}