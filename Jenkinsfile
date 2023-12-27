pipeline {
    agent any
    environment {
        DOCKER_HUB_REPO = "mathiascazals/projet_3"
        CONTAINER_NAME = "flask-container"
        STUB_VALUE = "200"
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
                    // Build and tag the Docker image
                    sh "docker image build -t $DOCKER_HUB_REPO:latest ."
                    sh "docker image tag $DOCKER_HUB_REPO:latest $DOCKER_HUB_REPO:$BUILD_NUMBER"
                    
                    // Push the Docker image to Docker Hub
                    withCredentials([usernamePassword(credentialsId: 'your-credentials-id', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
                        sh "docker login -u $DOCKER_USERNAME -p $DOCKER_PASSWORD"
                        sh "docker push $DOCKER_HUB_REPO:$BUILD_NUMBER"
                        sh "docker push $DOCKER_HUB_REPO:latest"
                        sh "docker logout"
                    }
                    
                    echo "Image built and pushed to repository"
                }
            }
        }
        stage('Deploy') {
            steps {
                script {
                    if (BUILD_NUMBER == "1") {
                        sh "docker run --name $CONTAINER_NAME -d -p 5000:5000 $DOCKER_HUB_REPO"
                    } else {
                        sh "docker stop $CONTAINER_NAME"
                        sh "docker rm $CONTAINER_NAME"
                        sh "docker run --name $CONTAINER_NAME -d -p 5000:5000 $DOCKER_HUB_REPO"
                    }
                }
            }
        }
    }
}
