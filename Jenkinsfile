pipeline {
  agent {
    docker { image "openjdk:11-jdk" }
  }
  stages {
    stage('Build') {
      steps {
        sh 'chmod +x gradlew'
        sh './gradlew build --console=plain'
      }
    }
    stage('Build-Docker') {
        steps {
          docker.build("magmafoundation/magma-api")
        }
      }
    stage('Release') {
      when {
          not {
              changeRequest()
          }
      }
      steps {
        withCredentials([string(credentialsId: 'REPO_USERNAME', variable: 'REPO_USERNAME'),string(credentialsId: 'REPO_PASSWORD', variable: 'REPO_PASSWORD')]) {
          sh 'chmod +x gradlew && ./gradlew publish --console=plain'
        }
      }
    }
  }
  post {
    always {
      script {
        archiveArtifacts artifacts: 'build/libs/*.jar', fingerprint: true, onlyIfSuccessful: true, allowEmptyArchive: true
      }
    }
  }
}