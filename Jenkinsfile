pipeline {
    agent any

    environment {
        GIT_BRANCH = "${env.GIT_BRANCH ?: 'develop'}"
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'develop', credentialsId: 'github-creds', url: 'https://github.com/arindam255064-ux/website.git'
            }
        }

        stage('Build/Test') {
            steps {
                echo "Running build and tests for branch ${GIT_BRANCH}"
                sh 'echo "Simulating build and test..."'
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
}

