pipeline{
    agent any
    
    options {
     buildDiscarder logRotator(artifactDaysToKeepStr: '', artifactNumToKeepStr: '2', daysToKeepStr: '1', numToKeepStr: '2')
          }
    stages{
        stage("Build Code"){
            
            steps{
               sh 'mvn clean install -DskipTests'
                
            }
		post {
                success {
                    echo 'Now Archiving...'
                    archiveArtifacts artifacts: '**/target/*.war'
                }
            }	
            
        }
    }
}    
