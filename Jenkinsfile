pipeline {
  agent any

  tools {
    jdk    'JDK_21'        // your Jenkins JDK install name
    maven  'Maven_3.9.10'  // your Jenkins Maven install name
  }

  environment {
    MAVEN_HOME      = tool('Maven_3.9.10')
    IMAGE_NAME      = 'my-java-app'
    CONTAINER_NAME  = 'my-java-app'
    HOST_PORT       = '8081'
    CONTAINER_PORT  = '8080'
    IMAGE_TAG       = "${BUILD_NUMBER}"
  }

  stages {
    stage('Clean') {
      steps { deleteDir() }
    }

    stage('Checkout') {
      steps {
        git url: 'https://github.com/MuhammadAbraiz/java-cicd.git', branch: 'main'
      }
    }

    stage('Build JAR') {
      steps {
        bat "\"%MAVEN_HOME%\\bin\\mvn\" clean package -DskipTests"
      }
    }

    stage('Build Docker Image') {
      steps {
        bat """
          copy /Y target\\*.jar app.jar
          docker build -t %IMAGE_NAME%:%IMAGE_TAG% .
        """
      }
    }

    stage('Deploy Container') {
      steps {
        bat """
          docker rm -f %CONTAINER_NAME% 2>nul || echo none
          docker run -d -p %HOST_PORT%:%CONTAINER_PORT% --name %CONTAINER_NAME% %IMAGE_NAME%:%IMAGE_TAG%
        """
      }
    }

    stage('Health Check') {
      steps {
        echo "🔍 Waiting for http://localhost:%HOST_PORT%/actuator/health"
        powershell """
          for ($i=0; $i -lt 6; $i++) {
            try {
              $resp = Invoke-RestMethod -Uri http://localhost:%HOST_PORT%/actuator/health -UseBasicParsing
              if ($resp.status -eq 'UP') {
                Write-Host '✅ App is healthy!'
                exit 0
              }
            } catch {}
            Start-Sleep -Seconds 5
          }
          Write-Error '❌ Health check failed after retries'
          exit 1
        """
      }
    }
  }

  post {
    success {
      echo "🚀 Application live at http://localhost:${HOST_PORT}"
    }
    failure {
      echo "❌ Deployment failed; container logs below:"
      bat "docker logs %CONTAINER_NAME% || echo No logs found"
    }
    always {
      echo "🧹 Cleaning up Docker artifacts"
      bat """
        docker rm -f %CONTAINER_NAME% 2>nul || echo none
        docker rmi -f %IMAGE_NAME%:%IMAGE_TAG% 2>nul || echo none
      """
    }
  }
}