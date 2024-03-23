pipeline{
    agent any
    stages{
        stage('SCM checkout'){
            steps{
            git branch: 'main', url: 'https://github.com/alekhya-510/ansible2012.git'
        }
        }
        stage('playbook execution') {
            steps{
            ansiblePlaybook colorized: true, credentialsId: 'anything', disableHostKeyChecking: true, installation: 'ansible', inventory: 'ansible.inv', playbook: 'playbook.yaml', vaultTmpPath: ''
        }
        }
    }
}
