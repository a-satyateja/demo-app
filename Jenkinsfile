node {
  try {
    stage('Cleanup Workspace'){
        echo 'Cleaning up the workspace'
        step([$class: 'WsCleanup'])
    } 
    //notifyBuild('STARTED')
    stage('Checkout stage'){
        echo 'Checking Out the code'
        checkout([$class: 'GitSCM', branches: [[name: 'master']], doGenerateSubmoduleConfigurations: false, extensions: [[$class: 'CleanBeforeCheckout']], submoduleCfg: [], userRemoteConfigs: [[credentialsId: 'github-access-token', url: 'https://github.com/Techolution/gcp-demo-app.git']]])
    }
    stage ('Build Docker Image')
    {
        sh "sudo docker build -t us.gcr.io/techo-gcp-practices/sample-app:build-id-${BUILD_NUMBER} ."
    }
    stage ('Push Docker Image to GCR')
    {
        sh "gcloud config list"
        sh "docker-credential-gcr configure-docker"
        sh "sudo docker push us.gcr.io/techo-gcp-practices/sample-app:build-id-${BUILD_NUMBER}"
    }
    stage ('deploy to kubernetes')
    {
     sh """
      gcloud container clusters get-credentials gke-workshop --zone us-east4-a --project techo-gcp-practices
      kubectl get ns
      kubectl apply -f sample-app.yaml && kubectl set image --namespace test deployment/sample-app sample-app=us.gcr.io/techo-gcp-practices/sample-app:build-id-${BUILD_NUMBER} 
     """
     }  
  }
  catch (e) {
     // If there was an exception thrown, the build failed
     throw e
     echo "error occured "
   } finally {
   echo "finally block reached"   }
}
