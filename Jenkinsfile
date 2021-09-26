pipeline {
    environment {
        ImageName = 'myhk2009/turn-based-api';
        DockerHubCredential = 'dockerHubCredential';
        GithubCredential = 'githubCredential';

        CURRENT_TIMESTAMP = GetTimestamp();
        CURRENT_ENV = GetEnvByBranch(BRANCH_NAME)
        IMAGE_TAG = "$CURRENT_ENV-$CURRENT_TIMESTAMP";
        HELM_CHART_VERSION = "1.0.0-$CURRENT_ENV.$CURRENT_TIMESTAMP";
        HELM_VALUE_FILE = GetHelmValueFile(CURRENT_ENV);
        
        HELM_OLD_VALUE_PATH = "backend-charts/api/$HELM_VALUE_FILE";
        HELM_NEW_VALUE_PATH = "backend-charts/api/new_value.yaml";
        HELM_OLD_CHART_PATH = "backend-charts/api/Chart.yaml";        
        HELM_NEW_CHART_PATH = "backend-charts/api/new_chart.yaml";
        HELM_CHART_HOME = "$HUDSON_HOME/workspace/turn-based-helm-chart"
    }

    agent {
        dockerfile true 
    }

    stages {
        // get rolling number from env
        // build & push image to docker hub
        // update tag in values.yaml
        // update config & push to github
                
        stage('Set Configs') {
            steps {
                script {
                    sh 'printenv | sort'                    
                }

                echo 'Current BRANCH_NAME: ' + BRANCH_NAME;
                echo 'CURRENT_ENV: ' + CURRENT_ENV;
                echo 'CURRENT_TIMESTAMP: ' + CURRENT_TIMESTAMP;
            }
        }

        stage('Building image') {
            steps{
                script {
                    sh 'ls'
                    dockerImage = docker.build(ImageName + ':' + IMAGE_TAG, './Api')
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
        
        stage('clone & update helm project'){
            steps{
                sh "chmod +x -R $WORKSPACE"
                sh './scripts/update-chart-files.sh';

                dir("$HUDSON_HOME/workspace/turn-based-helm-chart") {
                    sh 'rm -rf *'

                    git branch: "main",
                    credentialsId: 'githubCredential',
                    url: 'https://github.com/johnchan2016/turn-based-helm-chart.git'

                    withCredentials([usernamePassword(credentialsId: githubCredential, passwordVariable: 'GIT_PASSWORD', usernameVariable: 'GIT_USERNAME')]) {
                        script{
                            sh 'echo "check file list"'
                            sh 'ls'
                            sh 'cp -r $WORKSPACE/backend-charts/* $HUDSON_HOME/workspace/turn-based-helm-chart'

                            def encodedUser=URLEncoder.encode(GIT_USERNAME, "UTF-8")
                            def encodedPass=URLEncoder.encode(GIT_PASSWORD, "UTF-8")

                            sh 'git config --global user.name "johnchan"'
                            sh 'git config --global user.email myhk2009@gmail.com'

                            sh 'helm package api'
                            sh 'helm repo index --url https://johnchan2016.github.io/turn-based-api-chart .'
         
                            sh 'git add .'
                            sh 'git commit -m "create turn-based helm chart for version $IMAGE_TAG"'
                            sh 'git push https://' + encodedUser+ ':' + encodedPass + '@github.com/johnchan2016/turn-based-helm-chart.git'
                        }
                    }               
                }
            }
        }        
    }
}

def GetEnvByBranch(branchName){   
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
    def currentTimeStamp = now.format("yyyyMMddHHmm", TimeZone.getTimeZone('Asia/Hong_Kong'));

    return currentTimeStamp; 
}

def GetHelmValueFile(env){
    if (env == 'dev') {
        return 'values.yaml';
    } else if (env == 'uat' || env == 'prod'){
        return "values_$CurrentHelmPath.yaml"
    } else {
        return '';
    }
}