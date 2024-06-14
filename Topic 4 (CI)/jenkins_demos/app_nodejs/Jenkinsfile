pipeline {
    agent any

    stages {
        stage('Test') {
            steps {
                nodejs('node-16.14.0') {
                    sh '''
                    npm ci
                    npm test
                    '''
                }
            }
        }
    }    
}