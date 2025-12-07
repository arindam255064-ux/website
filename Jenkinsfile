pipeline {
    agent any

    environment {
        GIT_BRANCH = "${env.BRANCH_NAME ?: 'develop'}"
        DOCKER_IMAGE = "mywebapp:hshar"
        DOCKER_REGISTRY = "arindamnayak716" // Docker Hub username
    }

    stages {
        stage('Checkout') {
            steps {
                checkout([$class: 'GitSCM',
                    branches: [[name: "*/${GIT_BRANCH}"]],
                    doGenerateSubmoduleConfigurations: false,
                    extensions: [],
                    userRemoteConfigs: [[
                        url: 'https://github.com/arindam255064-ux/website.git',
                        credentialsId: 'github-creds'
                    ]]
                ])
            }
        }

        stage('Build/Test') {
            steps {
                echo "Running build and tests for branch ${GIT_BRANCH}"
                sh 'echo "Simulating build and test..."'
            }
        }

        stage('Build Docker Image') {
            steps {
                echo "Building Docker image..."
                sh "docker build -t ${DOCKER_REGISTRY}/${DOCKER_IMAGE} ."
            }
        }

        stage('Push Docker Image') {
            steps {
                echo "Pushing Docker image to Docker Hub..."
                withCredentials([usernamePassword(credentialsId: 'dockerhub-credentials', usernameVariable: 'DOCKERHUB_USERNAME', passwordVariable: 'DOCKERHUB_PASSWORD')]) {
                    sh '''
                        echo $DOCKERHUB_PASSWORD | docker login -u $DOCKERHUB_USERNAME --password-stdin
                        docker push $DOCKERHUB_USERNAME/${DOCKER_IMAGE}
                    '''
                }
            }
        }

        stage('Deploy to Production') {
            when {
                expression { env.GIT_BRANCH == 'master' }
            }
            steps {
                echo "Deploying to production..."
                sh 'ansible-playbook /etc/ansible/deploy.yaml'
            }
        }
    }

    post {
        success {
            echo "✅ Pipeline executed successfully!"
        }
        failure {
            echo "❌ Pipeline failed. Check logs."
        }
    }
}
