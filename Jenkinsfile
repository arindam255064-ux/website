pipeline {
    agent any

    environment {
        // Default to 'develop' if branch not set
        GIT_BRANCH = "${env.BRANCH_NAME ?: 'develop'}"
    }

    stages {
        stage('Checkout') {
            steps {
                checkout([$class: 'GitSCM',
                    branches: [[name: '*/develop']],
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

        stage('Deploy to Production') {
            when {
                expression { env.BRANCH_NAME == 'master' }
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
