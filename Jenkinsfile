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
                    def scannerHome = tool 'SonarQube Scanner' // Matches Jenkins Global Tool Configuration
                    withSonarQubeEnv('SonarQube Server') { // Matches Jenkins SonarQube Server configuration
                        sh """
                            export JAVA_HOME=/usr/lib/jvm/java-17-amazon-corretto.x86_64
                            export PATH=$JAVA_HOME/bin:$PATH
                            ${scannerHome}/bin/sonar-scanner \
                                -Dsonar.projectKey=testapi28 \
                                -Dsonar.sources=. \
                                -Dsonar.host.url=http://3.80.133.83:9000 \
                                -Dsonar.login=${env.SONAR_TOKEN}
                        """
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
