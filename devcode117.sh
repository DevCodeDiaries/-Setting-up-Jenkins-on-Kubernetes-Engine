export PROJECT_ID=$(gcloud config get-value project)
export ZONE=us-east1-c
gcloud config set compute/zone $ZONE

# Clone sample repo
git clone https://github.com/GoogleCloudPlatform/continuous-deployment-on-kubernetes.git
cd continuous-deployment-on-kubernetes

# Create GKE cluster
gcloud container clusters create jenkins-cd \
  --num-nodes 2 \
  --zone=$ZONE \
  --scopes "https://www.googleapis.com/auth/projecthosting,cloud-platform"

# Authenticate kubectl with the cluster
gcloud container clusters get-credentials jenkins-cd --zone=$ZONE

# Verify connection
kubectl cluster-info

# Add Helm repo
helm repo add jenkins https://charts.jenkins.io
helm repo update

# Install Jenkins via Helm
helm upgrade --install -f jenkins/values.yaml myjenkins jenkins/jenkins
