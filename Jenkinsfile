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
                echo "STUB_VALUE = ${STUB_VALUE}"
                sh "sed -i 's/<STUB_VALUE>/$STUB_VALUE/g' config.py"
                sh 'cat config.py'
            }
        }
        stage('Build and Push') {
            steps {
                script {
                    // Build and tag the Docker image using the specified Docker binary path
                    sh "${DOCKER_BINARY} image build -t $DOCKER_HUB_REPO:latest ."
                    sh "${DOCKER_BINARY} image tag $DOCKER_HUB_REPO:latest $DOCKER_HUB_REPO:$BUILD_NUMBER"

                    // Push the Docker image to Docker Hub
                    withCredentials([usernamePassword(credentialsId: 'your-credentials-id', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
                        sh "${DOCKER_BINARY} login -u $DOCKER_USERNAME -p $DOCKER_PASSWORD"
                        sh "${DOCKER_BINARY} push $DOCKER_HUB_REPO:$BUILD_NUMBER"
                        sh "${DOCKER_BINARY} push $DOCKER_HUB_REPO:latest"
                        sh "${DOCKER_BINARY} logout"
                    }

                    echo "Image built and pushed to repository"
                }
            }
        }
        stage('Deploy') {
            steps {
                script {
                    if (BUILD_NUMBER == "1") {
                        sh "${DOCKER_BINARY} run --name $CONTAINER_NAME -d -p 5000:5000 $DOCKER_HUB_REPO"
                    } else {
                        sh "${DOCKER_BINARY} stop $CONTAINER_NAME"
                        sh "${DOCKER_BINARY} rm $CONTAINER_NAME"
                        sh "${DOCKER_BINARY} run --name $CONTAINER_NAME -d -p 5000:5000 $DOCKER_HUB_REPO"
                    }
                }
            }
        }
    }
}
