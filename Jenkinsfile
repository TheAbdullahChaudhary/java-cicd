pipeline {
    agent any

    environment {
        // Set your image name here
        IMAGE_NAME = 'nortwind-app'
        CONTAINER_NAME = 'nortwind-container'
        PORT = '8081'
    }

    stages {
        stage('Clean Workspace') {
            steps {
                cleanWs()
            }
        }
        stage('Checkout Code') {
            steps {
                checkout scm
            }
        }
        stage('Build with Maven') {
            steps {
                // Use Maven to build the project
                sh './mvnw clean package -DskipTests=false'
            }
        }
        stage('Run Tests') {
            steps {
                // Run tests separately if needed
                sh './mvnw test'
            }
        }
        stage('Build Docker Image') {
            steps {
                script {
                    // Build Docker image using Dockerfile in project root
                    sh "docker build -t ${IMAGE_NAME}:latest ."
                }
            }
        }
        stage('Deploy Container') {
            steps {
                script {
                    // Stop and remove any existing container
                    sh "docker rm -f ${CONTAINER_NAME} || true"
                    // Run the new container
                    sh "docker run -d --name ${CONTAINER_NAME} -p ${PORT}:8080 ${IMAGE_NAME}:latest"
                }
            }
        }
    }
    post {
        always {
            // Optionally, clean up workspace after build
            cleanWs()
        }
    }
}
