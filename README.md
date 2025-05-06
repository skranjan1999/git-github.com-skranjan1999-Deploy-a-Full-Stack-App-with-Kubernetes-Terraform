🚀 Build and Deploy a Full-Stack App with Kubernetes + Terraform (Beginner Friendly)

🔧 Tech Stack: Terraform, Kubernetes, Minikube, Docker, Flask, React (HTML/CSS/JS)



🌟 What I Built
I created a complete Full-Stack Web Application and deployed it using Kubernetes and Terraform — all on my local system using Minikube!

This project includes: 

✅ A Python Flask backend 

✅ A frontend using HTML, CSS, and JS (React version optional) 

✅ Docker containers for both frontend and backend 

✅ Kubernetes for deployment and scaling 

✅ Terraform to manage everything automatically 

✅ Shared storage and secure configuration 

✅ Autoscaling based on CPU usage



🧩 Tools You’ll Need (Install These First)
Make sure you have these installed on your machine:

🐳 Docker

📦 Minikube

📘 kubectl

🧱 Terraform

📁 Project Folder Structure

🔨 Step-by-Step Guide (You Can Do It Too!)

1️⃣ Start Minikube

minikube start
2️⃣ Build Docker Images Locally

cd backend
docker build -t saurabh70/backend:latest .
cd ../frontend
docker build -t saurabh70/frontend:latest .
3️⃣ Push to DockerHub
Make sure you're logged in first:

docker login
docker push saurabh70/backend:latest
docker push saurabh70/frontend:latest
4️⃣ Write Terraform Code
In the terraform/main.tf file, add Kubernetes deployment code (already shared in my GitHub ). This includes:

Backend + Frontend deployments

NodePort service for frontend

ClusterIP service for backend

ConfigMaps and Secrets

Persistent Volume

Autoscaler for backend pods

5️⃣ Deploy Everything with Terraform
cd terraform
terraform init
terraform apply
🟢 Type yes when prompted. This will deploy all resources automatically!

6️⃣ Access Your App
Get your Minikube IP:

minikube ip
Open your browser and visit:

http://<minikube-ip>:30080
You should see your frontend talking to the backend 🎉

🧠 What You'll Learn by Doing This
How to containerize your full-stack application

How to use Terraform to automate your infrastructure

How to deploy on Kubernetes using Minikube

How to configure autoscaling and shared storage

How to inject secure and flexible configurations using Secrets and ConfigMaps

Feel free to reach out if you want to discuss any doubts.
