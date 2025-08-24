pipeline {
    agent any
    environment {
        ANSIBLE_HOST_KEY_CHECKING = 'False'
    }
    stages {
        stage('Clean Workspace') {
            steps {
                cleanWs()
            }
        }

        stage('Checkout Code') {
            steps {
                git ''
            }
        }

        stage('Terraform Apply') {
            dir('terraform') {
                steps {
                    sh 'terraform init'
                    sh 'terraform apply -auto-approve'
                }
            }
        }

        stage('Wait for EC2 Ready') {
            steps {
                echo 'Sleeping to let EC2 initialize...'
                sleep time: 60, unit: 'SECONDS'
            }
        }

        stage('Run Ansible Role') {
            dir('ansible') {
                steps {
                    sshagent(credentials: ['ansible-ssh-key']) {
                        sh 'ansible-playbook -i aws_ec2.yaml playbook.yml'
                    }
                }
            }
        }
    }
    post {
        always {
            echo 'Job Completed'
        }
    }
}