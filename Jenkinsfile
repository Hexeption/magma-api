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
        checkout scm
        sh 'chmod +x gradlew'
        sh './gradlew build'
        stash includes: "**/build/libs/*.jar", name: "build"
      }
    }
    stage('maven-publish') {
      agent {
        docker {
         image "openjdk:11-jdk"
         reuseNode true
         }
      }
      when {
          not {
              changeRequest()
          }
      }
      steps {
        unstash "build"
        withCredentials([string(credentialsId: 'REPO_USERNAME', variable: 'REPO_USERNAME'),string(credentialsId: 'REPO_PASSWORD', variable: 'REPO_PASSWORD')]) {
          sh 'chmod +x gradlew && ./gradlew publish --console=plain'
        }
      }
    }
    stage('docker-build') {
      steps {
        unstash "build"
        script {
          dockerImage = docker.build "hexeption/magma-api" + ":$BUILD_NUMBER"
          dockerImage.push()
        }
      }
    }
  }
}