pipeline {
    agent any

    environment {
        // Default to 'develop' if branch not set
        GIT_BRANCH = "${env.BRANCH_NAME ?: 'develop'}"
        DOCKER_IMAGE = "mywebapp:hshar"
        DOCKER_REGISTRY = "arindamnayak716" // Replace with your Docker Hub username
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
                echo "Building Docker image ${DOCKER_IMAGE}..."
                sh "docker build -t ${DOCKER_IMAGE} ."
            }
        }

        stage('Push Docker Image') {
            steps {
                script {
                    if (env.GIT_BRANCH == 'master') {
                        echo "Pushing Docker image to Docker Hub..."
                        withCredentials([usernamePassword(credentialsId: 'dockerhub-credentials', usernameVariable: 'USER', passwordVariable: 'PASS')]) {
                            sh "echo $PASS | docker login -u $USER --password-stdin"
                            sh "docker tag ${DOCKER_IMAGE} ${DOCKER_REGISTRY}/${DOCKER_IMAGE}"
                            sh "docker push ${DOCKER_REGISTRY}/${DOCKER_IMAGE}"
                        }
                    } else {
                        echo "Skipping Docker push for branch ${GIT_BRANCH}"
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
