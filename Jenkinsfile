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
                sh 'rm -r turn-based-helm-chart'
                sh 'git clone https://github.com/johnchan2016/turn-based-helm-chart.git'
                sh 'cp -r backend-charts/api/* turn-based-helm-chart/api'
                sh 'cd turn-based-helm-chart'

                withCredentials([usernamePassword(credentialsId: githubCredential, passwordVariable: 'GIT_PASSWORD', usernameVariable: 'GIT_USERNAME')]) {
                    env.encodedUser=URLEncoder.encode(GIT_USERNAME, "UTF-8")
                    env.encodedPass=URLEncoder.encode(GIT_PASSWORD, "UTF-8")

                    sh 'helm package turn-based-api-chart'
                    sh 'helm repo index --url https://github.com/johnchan2016/turn-based-helm-chart.git .'

                    sh "echo '***** get content of index.yaml *****'"
                    sh 'cat index.yaml'
                    sh "echo '***** *****'"
                    sh 'git add .'
                    sh 'git commit -m "create turn-based helm chart for version $IMAGE_TAG"'
                    sh 'git push https://${encodedUser}:${encodedPass}@github.com/johnchan2016/turn-based-helm-chart.git'
                }
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