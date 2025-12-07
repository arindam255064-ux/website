pipeline {
    agent any

    environment {
        GIT_BRANCH = "${env.BRANCH_NAME ?: 'develop'}"
        DOCKER_IMAGE = "mywebapp:hshar"               // Image name with tag
        DOCKERHUB_CREDENTIALS = "dockerhub-credentials" // Jenkins credentials ID
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
                script {
                    echo "Building Docker image..."
                    sh "docker build -t ${DOCKER_IMAGE} ."
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                script {
                    echo "Pushing Docker image to Docker Hub..."
                    withCredentials([usernamePassword(credentialsId: "${DOCKERHUB_CREDENTIALS}", usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
                        sh """
                        echo \$DOCKER_PASSWORD | docker login -u \$DOCKER_USERNAME --password-stdin
                        docker tag ${DOCKER_IMAGE} \$DOCKER_USERNAME/${DOCKER_IMAGE}
                        docker push \$DOCKER_USERNAME/${DOCKER_IMAGE}
                        """
                    }
                }
            }
        }

        stage('Deploy to Production') {
            when {
                expression { env.GIT_BRANCH == 'master' }
            }
            steps {
                echo "Deploying to production environment..."
                sh 'ansible-playbook /etc/ansible/deploy.yml'
            }
        }
    }

    post {
        success {
            echo "✅ Pipeline executed successfully!"
        }
        failure {
            echo "❌ Pipeline failed. Check logs for details."
        }
    }
}
