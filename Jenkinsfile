pipeline {
  agent none
  environment {
    dockerImage = ''
  }

  stages {
    stage('build') {
      agent {
        docker { image "openjdk:11-jdk" }
      }
      steps {
        sh 'chmod +x gradlew'
        sh './gradlew build'
      }
    }
    stage('maven-publish') {
      agent {
        docker { image "openjdk:11-jdk" }
      }
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
    stage('docker-build') {
      steps {
        script {
          dockerImage = docker.build "hexeption/magma-api" + ":$BUILD_NUMBER"
          dockerImage.push()
        }
      }
    }
  }
}