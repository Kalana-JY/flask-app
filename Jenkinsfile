pipeline {
    agent any

    environment {
        DOCKERHUB_CREDS = credentials('dockerhub-creds')
        AWS_ACCESS_KEY_ID = credentials('aws-access-key-id')
        AWS_SECRET_ACCESS_KEY = credentials('aws-secret-access-key')
        IMAGE_NAME = "kalanajy/hello-flask"
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t $IMAGE_NAME .'
            }
        }

        stage('Push to Docker Hub') {
            steps {
                sh '''
                    echo $DOCKERHUB_CREDS_PSW | docker login -u $DOCKERHUB_CREDS_USR --password-stdin
                    docker push $IMAGE_NAME
                '''
            }
        }

        stage('Terraform Apply') {
            steps {
                dir('terraform') {
                sh '''
                    terraform init
                    terraform apply -auto-approve -var="key_name=flask-key"
                '''
                    script {
                        env.INSTANCE_IP = sh(
                            script: "terraform output -raw instance_public_ip",
                            returnStdout: true
                        ).trim()
                    }
                }
            }
        }

        stage('Run Ansible Playbook') {
            steps {
                dir('ansible') {
                    sshagent(credentials: ['flask-ssh-key']) {
                        sh '''
                            echo "[web]" > inventory.ini
                            echo "$INSTANCE_IP ansible_user=ec2-user ansible_ssh_private_key_file=$HOME/.ssh/flask-key.pem" >> inventory.ini
                            ansible-playbook -i inventory.ini playbook.yml
                        '''
                    }
                }
            }
        }
    }

    post {
        success {
            echo 'Pipeline completed successfully! Flask app deployed.'
        }
        failure {
            echo 'Pipeline failed. Check the logs above.'
        }
    }
}