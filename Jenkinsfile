pipeline {
  agent none
  environment {
    dockerImage = ''
  }

  stages {
  stage('publish') {
        agent {
          docker { image "openjdk:11-jdk" }
        }
        steps {
          withCredentials([sshUserPrivateKey(credentialsId: '0926ae9f-2006-4164-bdf2-935caf03cb83', keyFileVariable: 'KEY_FILE')]) {
              sh "eval `ssh-agent -s` && ssh-add ${KEY_FILE} && ssh-add -L && ssh root@dedi.hexeption.co.uk 'docker stop magma-api' && ssh root@dedi.hexeption.co.uk 'docker rm magma-api' &&  ssh root@dedi.hexeption.co.uk 'docker run -d --name magma-api -p 1394:8080 hexeption/magma-api:20'"
          }
        }
      }

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

  }
}