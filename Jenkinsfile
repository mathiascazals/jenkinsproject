stages {
        stage('Stubs-Replacement'){
            steps {
                // 'STUB_VALUE' Environment Variable declared in Jenkins Configuration 
                echo "STUB_VALUE = ${STUB_VALUE}"
                sh "sed -i 's/<STUB_VALUE>/$STUB_VALUE/g' config.py"
                sh 'cat config.py'
            }
        }
        stage('Build') {
            steps {
                //  Building new image
                sh 'docker image build -t mathiascazals/projet_3:latest .'
                sh 'docker image tag mathiascazals/projet_3:latest mathiascazals/projet_3:$BUILD_NUMBER'

                //  Pushing Image to Repository
                sh 'docker push mathiascazals/projet_3:$BUILD_NUMBER'
                sh 'docker push mathiascazals/projet_3:latest'
                
                echo "Image built and pushed to repository"
            }
        }
        stage('Deploy') {
            steps {
                script{
                    //sh 'BUILD_NUMBER = ${BUILD_NUMBER}'
                    if (BUILD_NUMBER == "8") {
                        sh 'docker run --name $CONTAINER_NAME -d -p 5000:5000 $DOCKER_HUB_REPO'
                    }
                    else {
                        sh 'docker stop $CONTAINER_NAME'
                        sh 'docker rm $CONTAINER_NAME'
                        sh 'docker run --name $CONTAINER_NAME -d -p 5000:5000 $DOCKER_HUB_REPO'
                    }
                    //sh 'echo "Latest image/code deployed"'
                }
            }
        }
    }
