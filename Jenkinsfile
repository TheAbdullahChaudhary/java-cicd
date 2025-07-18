pipeline {
    agent any

    tools {
        maven 'Maven 3.9.11' // Use the Maven tool name as configured in Jenkins
        jdk 'JDK'            // Use the JDK tool name as configured in Jenkins
    }

    environment {
        IMAGE_NAME = 'nortwind-app'
        CONTAINER_NAME = 'nortwind-container'
        HOST_PORT = '8081'
        CONTAINER_PORT = '8081'
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }
        stage('Build') {
            steps {
                sh 'mvn clean package -DskipTests'
            }
        }
        stage('Build Docker Image') {
            steps {
                sh "docker build -t $IMAGE_NAME ."
            }
        }
        stage('Deploy Docker Container') {
            steps {
                sh "docker stop $CONTAINER_NAME || true"
                sh "docker rm $CONTAINER_NAME || true"
                sh "docker run -d --name $CONTAINER_NAME -p $HOST_PORT:$CONTAINER_PORT $IMAGE_NAME"
            }
        }
    }
    post {
        always {
            archiveArtifacts artifacts: '**/target/*.jar', fingerprint: true
        }
    }
}