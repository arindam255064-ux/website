pipeline {
    agent any

    environment {
        ANSIBLE_HOSTS = '/etc/ansible/hosts'
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: "${BRANCH_NAME}", credentialsId: 'github-creds', url: 'https://github.com/arindam255064-ux/website.git'
            }
        }

        stage('Build/Test') {
            steps {
                echo "Running tests for branch ${BRANCH_NAME}"
                sh 'echo "Simulating build and tests..."'
            }
        }

        stage('Deploy to Production') {
            when {
                branch 'master'
            }
            steps {
                echo "Deploying to Production..."
                sh 'ansible-playbook /etc/ansible/deploy.yml'
            }
        }
    }
}
