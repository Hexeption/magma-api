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
        sh './gradlew build --no-daemon'
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
      steps {
        unstash "build"
        withCredentials([string(credentialsId: 'REPO_USERNAME', variable: 'REPO_USERNAME'),string(credentialsId: 'REPO_PASSWORD', variable: 'REPO_PASSWORD')]) {
          sh 'chmod +x gradlew && ./gradlew publish --console=plain --no-daemon'
        }
      }
    }
    stage('docker-build') {
      steps {
        withCredentials([string(credentialsId: 'REPO_USERNAME', variable: 'REPO_USERNAME'),string(credentialsId: 'REPO_PASSWORD', variable: 'REPO_PASSWORD')]) {
          script {
            dockerImage = docker.build("hexeption/magma-api:$BUILD_NUMBER", "--no-cache . --build-arg REPO_USERNAME_VAR=$REPO_USERNAME --build-arg  REPO_PASSWORD_VAR=$REPO_PASSWORD")
            dockerImage.push()
          }
        }
      }
    }
    stage('publish') {
      steps {
        sshagent(credentials : ['host-pem']) {
          sh 'ssh -v root@dedi.hexeption.co.uk'
          sh "docker run -d --name magma-api -p 1394:8080 hexeption/magma-api:$BUILD_NUMBER"
        }
      }
    }
  }
}