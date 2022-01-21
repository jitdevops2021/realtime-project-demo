pipeline{
    agent any
    
    options {
     buildDiscarder logRotator(artifactDaysToKeepStr: '', artifactNumToKeepStr: '2', daysToKeepStr: '1', numToKeepStr: '2')
          }
    stages{
        stage("Sonar qube quality check"){
            agent {
                docker {
                    image 'maven:3.8.1-adoptopenjdk-11'
                    
                }
            }
            steps{
               sh 'mvn clean install'
                
            }
            
        }
    }
}    
		
