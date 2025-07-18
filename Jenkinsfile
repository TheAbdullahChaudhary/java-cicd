pipeline {
    agent any

    tools {
        maven 'Maven 3.9.11' // Use the Maven tool name as configured in Jenkins
        jdk 'JDK'            // Use the JDK tool name as configured in Jenkins
    }

    environment {
        JAVA_HOME = tool('JDK_21')
        MAVEN_HOME = tool('maven')
        IMAGE_NAME = 'my-java-app'
        CONTAINER_NAME = 'my-java-app'
        APP_PORT = '8081'
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
                echo "🚀 Deploying Docker container..."
                bat """
                    docker rm -f %CONTAINER_NAME% 2>nul || echo no old container
                    docker run -d -p %APP_PORT%:%APP_PORT% --name %CONTAINER_NAME% %IMAGE_NAME%
                """
            }
        }
        stage('Health Check') {
            steps {
                echo "🔍 Hitting /actuator/health on http://localhost:%APP_PORT%"
                retry(5) {
                    bat "curl --fail http://localhost:%APP_PORT%/actuator/health"
                }
            }
        }
    }
    post {
        always {
            archiveArtifacts artifacts: '**/target/*.jar', fingerprint: true
        }
    }
}