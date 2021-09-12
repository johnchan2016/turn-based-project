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
        imageName = 'myhk2009/turn-based-api';
        dockerHubCredential = 'dockerHubCredential';
        githubCredential = 'githubCredential';
        currentEnv = '';
        currentTimestamp = '';
        currentHelmPath = '';
    }

    agent any

    stages {
        // get rolling number from env
        // build & push image to docker hub
        // update tag in values.yaml
        // update config & push to github
        stage("Set Configs") {
            steps {
                sh('printenv | sort')
                currentTimestamp = GetTimestamp();
                currentEnv = GetEnvByBranch(env.BRANCH_NAME)
                currentHelmPath = GetHelmValuePath(currentEnv);
                
                echo "Current BRANCH_NAME: " + env.BRANCH_NAME;
                echo "currentEnv: " + currentEnv;
                echo "currentTimestamp: " + currentTimestamp 
            }
        }

        stage('Building image') {
            steps{
                script {
                    dockerImage = docker.build(imageName + ':' + currentTimestamp + '-' + currentEnv)
                }
            }
        }

        stage('Deploy Image') {
            steps{
                script {
                    docker.withRegistry( 'https://registry.hub.docker.com', dockerHubCredential ) {
                        dockerImage.push()
                    }
                }
            }
        }

        stage('update tag in values.yaml'){
            steps {
                if (currentEnv == '') {
                    return;
                }

                sh 'yq w ./backend-charts/api/values-${env.CurrentEnv}.yaml image.tag ${env.CurrentTimestamp}-${env.CurrentEnv}';
                sh 'cat ./backend-charts/api/values-${env.CurrentEnv}.yaml'
            }
        }

        /*
        stage('helm-chart') {
            steps {
                dir("helm-chart") {
                    deleteDir()
                }

                 sh 'git clone https://github.com/johnchan2016/helm-chart.git'

                 dir("helm-chart") {
                    withCredentials([usernamePassword(credentialsId: githubCredential, passwordVariable: 'GIT_PASSWORD', usernameVariable: 'GIT_USERNAME')]) {
                        script {
                            env.encodedUser=URLEncoder.encode(GIT_USERNAME, "UTF-8")
                            env.encodedPass=URLEncoder.encode(GIT_PASSWORD, "UTF-8")

                            if (fileExists("${HELM_ENVFILE}")) {
                                sh "rm -rf  ${HELM_ENVFILE}"
                            }
                                                    
                            sh 'git config --global user.name "johnchan"'
                            sh 'git config --global user.email myhk2009@gmail.com'
                            sh "echo VERSION=${env.VERSION} >> ${HELM_ENVFILE}"
                            sh "echo REGION=${REGION} >> ${HELM_ENVFILE}"

                            def gitStatus = sh(script: 'git status', returnStdout: true)
                            echo "gitStatus: ${gitStatus}"
                            if (gitStatus =~ /(.*)nothing to commit(.*)/){
                                echo 'nothing to commit'
                            } else {
                                sh 'git add .'
                                sh "git commit -m 'Update version no to ${env.VERSION}'"
                                sh 'git push https://${encodedUser}:${encodedPass}@github.com/johnchan2016/helm-chart.git'

                                sh 'cp ./backend-charts/api ./helm-chart';
                                sh 'git push https://${encodedUser}:${encodedPass}@github.com/johnchan2016/.git'

                                sh 'git add .'
                                sh "git commit -m 'Update version no to ${env.VERSION}'"
                                sh 'git push https://${encodedUser}:${encodedPass}@github.com/johnchan2016/helm-chart.git'
                            }
                        }
                    }
                }
            }
        }
        */
    }
}

def SetEnvByBranch(branchName){
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

def GetHelmValuePath(env){
    if (env == 'dev') {
        return ''
    } else if (env == 'uat'){
        return 'uat';
    } else if (env == 'prod'){
        return 'prod';
    } else {
        return '';
    }
}

def GetTimestamp(){
    def timestamp = date '+%Y%m%d%H%M';
    println "Current Timestamp: " + timestamp;
    return timestamp;
}