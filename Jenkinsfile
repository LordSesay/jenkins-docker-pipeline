pipeline {
    agent any
    
    environment {
        AWS_REGION = 'us-east-1'
        IMAGE_NAME = 'my-app'
        IMAGE_TAG = "${BUILD_NUMBER}"
    }
    
    options { 
        timestamps()
        timeout(time: 30, unit: 'MINUTES')
    }
    
    stages {
        stage('Build') {
            steps {
                script {
                    docker.withRegistry('https://index.docker.io/v1/', 'dockerhub-credentials') {
                        def image = docker.build("${IMAGE_NAME}:${IMAGE_TAG}")
                    }
                }
            }
        }
        
        stage('Test') {
            steps {
                script {
                    // Run tests by executing npm test in the container
                    sh "docker run --rm ${IMAGE_NAME}:${IMAGE_TAG} npm test"
                }
            }
        }
        
        stage('Push to ECR') {
            steps {
                script {
                    withCredentials([aws(credentialsId: 'aws-credentials')]) {
                        // Get AWS account ID and build ECR registry URL
                        def accountId = sh(script: 'aws sts get-caller-identity --query Account --output text', returnStdout: true).trim()
                        def ecrRegistry = "${accountId}.dkr.ecr.${AWS_REGION}.amazonaws.com"
                        
                        // ECR login
                        sh "aws ecr get-login-password --region ${AWS_REGION} | docker login --username AWS --password-stdin ${ecrRegistry}"
                        
                        // Tag and push images
                        sh "docker tag ${IMAGE_NAME}:${IMAGE_TAG} ${ecrRegistry}/${IMAGE_NAME}:${IMAGE_TAG}"
                        sh "docker tag ${IMAGE_NAME}:${IMAGE_TAG} ${ecrRegistry}/${IMAGE_NAME}:latest"
                        sh "docker push ${ecrRegistry}/${IMAGE_NAME}:${IMAGE_TAG}"
                        sh "docker push ${ecrRegistry}/${IMAGE_NAME}:latest"
                    }
                }
            }
        }
    }
    
    post {
        always {
            script {
                try {
                    sh "docker stop \$(docker ps -q --filter ancestor=${IMAGE_NAME}:${IMAGE_TAG}) || true"
                    sh "docker rmi -f ${IMAGE_NAME}:${IMAGE_TAG} || true"
                    sh "docker image prune -f || true"
                } catch (Exception e) {
                    echo "Cleanup failed: ${e.getMessage()}"
                }
            }
        }
        success {
            echo 'Pipeline completed successfully!'
        }
        failure {
            echo 'Pipeline failed!'
        }
    }
}