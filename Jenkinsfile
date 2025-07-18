pipeline {
  agent any

  tools {
    jdk 'JDK_21'
    maven 'Maven_3.9.10'
  }

  environment {
    JAVA_HOME      = tool('JDK_21')
    MAVEN_HOME     = tool('Maven_3.9.10')
    IMAGE_NAME     = 'my-java-app'
    CONTAINER_NAME = 'my-java-app'
    HOST_PORT      = '8081'
    CONTAINER_PORT = '8080'
  }

  stages {
    stage('Clean Workspace') {
      steps {
        echo "🧹 Cleaning workspace..."
        script {
          try {
            deleteDir()
          } catch (err) {
            echo "❗ deleteDir() failed, falling back to batch clean: ${err}"
            bat '''
              for /d %%D in (*) do rmdir /s /q "%%D" 2>nul || echo ignore
              del /f /q *.* 2>nul || echo ignore
            '''
          }
        }
      }
    }

    stage('Checkout') {
      steps {
        echo "🔁 Cloning repository..."
        git url: 'https://github.com/MuhammadAbraiz/java-cicd.git', branch: 'main'
      }
    }

    stage('Build JAR') {
      steps {
        echo "🔨 Building with Maven (skip tests)..."
        bat "\"%MAVEN_HOME%\\bin\\mvn\" clean package -DskipTests"
        // Fail early if no jar produced
        bat '''
          if not exist target\\*.jar (
            echo ❌ No JAR found && exit /b 1
          )
        '''
      }
    }

    stage('Verify Docker') {
      steps {
        echo "🐳 Verifying Docker..."
        bat 'docker --version'
        bat 'docker info'
      }
    }

    stage('Build Docker Image') {
      steps {
        echo "🐳 Building Docker image..."
        bat '''
          copy /Y target\\*.jar app.jar
          docker build -t %IMAGE_NAME%:%BUILD_NUMBER% .
        '''
      }
    }

    stage('Run Container') {
      steps {
        echo "🚀 Starting container..."
        bat '''
          docker rm -f %CONTAINER_NAME% 2>nul || echo none
          docker run -d -p %HOST_PORT%:%CONTAINER_PORT% --name %CONTAINER_NAME% %IMAGE_NAME%:%BUILD_NUMBER%
        '''
      }
    }

    stage('Health Check') {
      steps {
        echo "🔍 Polling Actuator health endpoint..."
        script {
          // Give the container a moment to start
          sleep(time: 10, unit: 'SECONDS')
          
          retry(6) {
            bat '''
              powershell -Command "try { $r = Invoke-WebRequest -Uri http://localhost:%HOST_PORT%/actuator/health -UseBasicParsing -TimeoutSec 5; if ($r.StatusCode -eq 200) { Write-Host '✅ UP'; exit 0 } } catch { Write-Host '❌ Health check failed, retrying...'; exit 1 }"
            '''
          }
        }
      }
    }
  }

  post {
    always {
      echo "📦 Archiving build artifacts..."
      archiveArtifacts artifacts: '**/target/*.jar', allowEmptyArchive: true
    }
    success {
      echo "✅ Deployment succeeded! App is live at http://localhost:${HOST_PORT}/"
    }
    failure {
      echo "❌ Something broke—here's your container status & logs:"
      bat 'docker ps -a'
      bat 'docker logs %CONTAINER_NAME% || echo no logs'
    }
    // we leave container/image running so you can hit the URL afterward
  }
}