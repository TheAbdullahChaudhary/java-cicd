pipeline {
    agent any

    environment {
        JAVA_HOME = '/usr/lib/jvm/temurin-21-jdk-amd64'
        PATH = "${JAVA_HOME}/bin:${env.PATH}"
        IMAGE_NAME = 'nortwind-app'
        CONTAINER_NAME = 'nortwind-container'
        HOST_PORT = '8081'
        CONTAINER_PORT = '8080'
    }

    tools {
        maven 'Maven 3.9.11'
    }

    stages {
        stage('Clean Workspace') {
            steps {
                echo '🧹 Cleaning workspace...'
                deleteDir()
            }
        }

        stage('Clone Repo') {
            steps {
                echo '🔁 Cloning GitHub repository...'
                withCredentials([usernamePassword(credentialsId: 'github-creds', usernameVariable: 'GIT_USER', passwordVariable: 'GIT_TOKEN')]) {
                    sh 'git clone https://$GIT_USER:$GIT_TOKEN@github.com/MuhammadAbraiz/java-cicd.git .'
                }
            }
        }

        stage('Build') {
            steps {
                echo '🔨 Building project with Maven...'
                sh 'mvn clean package -DskipTests'
            }
        }

        stage('Build Docker Image') {
            steps {
                echo '🐳 Building Docker image...'
                sh "docker build -t $IMAGE_NAME ."
            }
        }

        stage('Deploy Docker Container') {
            steps {
                echo '🚀 Deploying Docker container...'
                sh "docker stop $CONTAINER_NAME || true"
                sh "docker rm $CONTAINER_NAME || true"
                sh "docker run -d --name $CONTAINER_NAME -p $HOST_PORT:$CONTAINER_PORT $IMAGE_NAME"
            }
        }
    }

    post {
        always {
            echo '📦 Archiving JAR artifacts...'
            archiveArtifacts artifacts: '**/target/*.jar', fingerprint: true
        }
    }
}
