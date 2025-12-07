pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "docker6767/image"        // Replace with your Docker Hub repo
        DOCKER_REGISTRY = "docker.io"
        KUBE_DEPLOYMENT = "custom-deployment"
        KUBE_NAMESPACE = "default"
        KUBE_CONFIG = "/home/jenkins/.kube/config" // Jenkins kubeconfig path
    }

    triggers {
        pollSCM('H/5 * * * *') // Optional: poll every 5 mins for changes in master
    }

    stages {

        stage('Checkout') {
            steps {
                git branch: 'master', url: 'https://github.com/arindam255064-ux/website.git'
            }
        }

        stage('Check Release Date') {
            steps {
                script {
                    def today = new Date().format('dd', TimeZone.getTimeZone('UTC'))
                    if (today != '25') {
                        echo "Today is not 25th. Skipping deployment."
                        currentBuild.result = 'SUCCESS'
                        return
                    }
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    sh '''
                    echo "Building Docker image..."
                    docker build -t $DOCKER_IMAGE:latest .
                    echo "Logging in to Docker Hub..."
                    echo $DOCKERHUB_PASSWORD | docker login -u $DOCKERHUB_USERNAME --password-stdin
                    docker push $DOCKER_IMAGE:latest
                    '''
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                script {
                    sh '''
                    echo "Applying Kubernetes manifests..."
                    kubectl apply -f deploy.yaml
                    kubectl apply -f svc.yaml
                    kubectl rollout status deployment/$KUBE_DEPLOYMENT
                    '''
                }
            }
        }
    }

    post {
        success {
            echo "✅ Deployment completed successfully!"
        }
        failure {
            echo "❌ Deployment failed!"
        }
    }
}
