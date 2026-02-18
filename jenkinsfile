pipeline {
  agent any

  environment {
    AWS_REGION = "us-east-1"
    TF_IN_AUTOMATION = "true"
  }

  stages {
    stage('Checkout') {
      steps {
        checkout scm
      }
    }

    stage('Terraform Format & Validate') {
      steps {
        sh '''
          terraform fmt -check -recursive || true
          terraform validate
        '''
      }
    }

    stage('Terraform Init') {
      steps {
        sh '''
          terraform init -input=false
        '''
      }
    }

    stage('Terraform Plan') {
      steps {
        withCredentials([[$class: 'AmazonWebServicesCredentialsBinding',
                          credentialsId: 'aws-prod']]) {
          sh '''
            terraform plan -input=false -out=tfplan
          '''
        }
      }
      post {
        success {
          archiveArtifacts artifacts: 'tfplan', fingerprint: true
        }
      }
    }

    stage('Approve Apply') {
      steps {
        input message: 'Apply this Terraform plan?', ok: 'Apply'
      }
    }

    stage('Terraform Apply') {
      steps {
        withCredentials([[$class: 'AmazonWebServicesCredentialsBinding',
                          credentialsId: 'aws-prod']]) {
          sh '''
            terraform apply -input=false -auto-approve tfplan
          '''
        }
      }
    }
  }
}