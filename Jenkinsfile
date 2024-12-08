pipeline {
    agent any

    environment {
        SONAR_TOKEN = credentials('2536478')
        AWS_CREDS = credentials('bc434e21-5423-4961-bf6a-40aff751bfa3')
    }


    stages {
        stage('Clone Repository') {
            steps {
                git branch: 'main', url: 'https://github.com/crowntailtech/terraformtest.git'
            }
        }

        stage('Code Analysis with SonarQube') {
            steps {
                script {
                    def scannerHome = tool 'SonarQube Scanner'
                    withSonarQubeEnv('SonarQube Server') {
                        sh "${scannerHome}/bin/sonar-scanner \
                            -Dsonar.projectKey=my-actual-project-key \
                            -Dsonar.sources=. \
                            -Dsonar.host.url=http://127.0.0.1:9000 \
                            -Dsonar.login=${SONAR_TOKEN}"
                    }
                }
            }
        }

        stage('Terraform Plan & Apply') {
            steps {
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: AWS_CREDS]]) {
                    sh '''
                        terraform init
                        terraform plan
                        terraform apply -auto-approve
                    '''
                }
            }
        }
    }

    post {
        always {
            echo 'Pipeline execution completed.'
        }
        success {
            echo 'Pipeline completed successfully!'
        }
        failure {
            echo 'Pipeline failed. Check logs for more details.'
        }
    }
}
