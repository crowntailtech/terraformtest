pipeline {
    agent any
    environment {
        SONARQUBE_URL = 'http://127.0.0.1:9000'
        SONARQUBE_TOKEN = credentials('sonarqube-token')
    }
    stages {
        stage('Checkout') {
            steps {
                git 'https://github.com/crowntailtech/terraformtest.git'
            }
        }
        stage('Build') {
            steps {
                echo 'Building...'
            }
        }
        stage('Code Analysis') {
            steps {
                withSonarQubeEnv('SonarQube') {
                    sh 'sonar-scanner -Dsonar.projectKey=my-api -Dsonar.sources=./ -Dsonar.host.url=$SONARQUBE_URL -Dsonar.login=$SONARQUBE_TOKEN'
                }
            }
        }
        stage('Deploy') {
            steps {
                sh 'scp -i <key.pem> main.py ec2-user@54.145.164.100:/home/ec2-user/'
                sh 'ssh -i <key.pem> ec2-user@54.145.164.100 "uvicorn main:app --host 0.0.0.0 --port 8000 &"'
            }
        }
    }
}
