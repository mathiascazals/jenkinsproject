pipeline {
    agent any
    environment {
        DOCKER_HUB_REPO = "mathiascazals/projet_3"
        CONTAINER_NAME = "flask-container"
        STUB_VALUE = "200"
        DOCKER_BINARY = "/usr/bin/docker"
    }
    stages {
        stage('Stubs-Replacement') {
            steps {
                // 'STUB_VALUE' Environment Variable declared in Jenkins Configuration 
                echo "STUB_VALUE = ${STUB_VALUE}"
                sh "sed -i 's/<STUB_VALUE>/$STUB_VALUE/g' config.py"
                sh 'cat config.py'
            }
        }
        stage('Build') {
            steps {
                // Building new image
                sh "$DOCKER_BINARY image build -t $DOCKER_HUB_REPO:latest https://github.com/mathiascazals/jenkinsproject"
                sh "$DOCKER_BINARY image tag $DOCKER_HUB_REPO:latest $DOCKER_HUB_REPO:$BUILD_NUMBER"

                // Pushing Image to Repository
                sh "$DOCKER_BINARY push $DOCKER_HUB_REPO:$BUILD_NUMBER"
                sh "$DOCKER_BINARY push $DOCKER_HUB_REPO:latest"
                
                echo "Image built and pushed to repository"
            }
        }
        stage('Deploy') {
            steps {
                script {
                    // sh 'BUILD_NUMBER = ${BUILD_NUMBER}'
                    if (BUILD_NUMBER == "20") {
                        sh "$DOCKER_BINARY run --name $CONTAINER_NAME -d -p 5000:5000 $DOCKER_HUB_REPO"
                    } else {
                        sh "$DOCKER_BINARY stop $CONTAINER_NAME"
                        sh "$DOCKER_BINARY rm $CONTAINER_NAME"
                        sh "$DOCKER_BINARY run --name $CONTAINER_NAME -d -p 5000:5000 $DOCKER_HUB_REPO"
                    }
                    // sh 'echo "Latest image/code deployed"'
                }
            }
        }
    }
}
