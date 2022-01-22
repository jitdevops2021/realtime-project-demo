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
                    archiveArtifacts artifacts: '**/target/*.jar'
                }
            }	
            
        }
		
	stage('UNIT TEST'){
            steps {
                sh 'mvn test'
            }
        }

	stage('INTEGRATION TEST'){
            steps {
                sh 'mvn verify -DskipUnitTests'
            }
        }
	stage('build docker image from file'){
            steps{
                sh 'docker image build -t swap007.azurecr.io/realtime-project-demo:${BUILD_NUMBER} .'
            }
        }
		
    stage("Login to the azure acr and push  the docker image to acr registry"){
            steps{
                withCredentials([usernamePassword(credentialsId: 'azure-acr-credentials', passwordVariable: 'DOCKER_PASSWORD', usernameVariable: 'DOCKER_USER')]) {
				sh 'docker login -u ${DOCKER_USER} -p ${DOCKER_PASSWORD} swap007.azurecr.io'
				sh 'docker image push swap007.azurecr.io/realtime-project-demo:${BUILD_NUMBER}'
				}
            }
        }	
		
	stage('indentifying misconfigs using datree in helm charts'){
            steps{
                script{

                    dir('kubernetes/') {
                        withEnv(['DATREE_TOKEN=VP2GzjBCP48nfiJBZujtqn']) {
			      			      
                              sh 'helm datree test myapp/'
                        }
                    }
                }
            }
        }	
    stage("pushing the helm charts to nexus"){
            steps{
                script{
                    withCredentials([string(credentialsId: 'nexus_passwd', variable: 'docker_password')]) {
                          dir('kubernetes/') {
                             sh '''
                                 helmversion=$( helm show chart myapp | grep version | cut -d: -f 2 | tr -d ' ')
                                 tar -czvf  myapp-${helmversion}.tgz myapp/
                                 curl -u admin:$docker_password http://13.232.26.147:8081/repository/helm-hosted/ --upload-file myapp-${helmversion}.tgz -v
                            '''
                          }
                    }
                }
            }
        }
	
	
    }
}    
