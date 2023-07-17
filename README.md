# Oracle Cloud Project

This project will create a WebServer for the project Dropwizard to run in Oracle Cloud. It will also create all the necessary resources to support this project such as Load Balancers, Bastion Server, Grafana and Prometheus, etc.

<img width="494" alt="image" src="https://github.com/larocas/oci-project/assets/139692500/b0b076d4-2df4-4aba-9779-55bfdacff935">

## Infrastructure development
Create the underlying infrastructure of this project:
```
# Clone this repository to your local
git clone git@github.com:larocas/oci-project.git

# Crate the env variables for OCI authenticatio
export TF_VAR_tenancy_ocid=<YourValue>
export TF_VAR_user_ocid=<YourValue>
export TF_VAR_fingerprint=<YourValue>
export TF_VAR_private_key_path=<YourValue>

# Create the Infrastructure Using Terraform
cd infrastructure
terraform init
terraform plan
terraform apply
```
## Application Development 

We will be running a Dropwizard Java application. The Dropwizard example application was developed to, as its name implies, provide examples of some of the features present in Dropwizard. Im going to be following the doc on [dropwizard-example](https://github.com/dropwizard/dropwizard/tree/master/dropwizard-example).
```
git clone https://github.com/dropwizard/dropwizard.git
mvn package -Dmaven.test.skip
cd dropwizard-example
java -jar target/dropwizard-example-$DW_VERSION.jar db migrate example.yml
java -jar target/dropwizard-example-$DW_VERSION.jar server example.yml
```
You can now hit the Hello World example (http://localhost:8080/hello-world)

## Dockerize the Application
Using the Dockerfile of this project and the jar file obtained in the previous step we can create the Docker image and push it docher hub:
```
docker login -u larocasdelcastillo
docker image build -t larocasdelcastillo/luis-oracle-dropwizard:latest .
docker push larocasdelcastillo/luis-oracle-dropwizard:latest
```
## Deploy the Application
First, ssh into the web server and install all necessary components to run Docker in the Server:
```
ssh -i opc.pem opc@<BastionPublicIP>
ssh -i opc.pem opc@<WebServerPrivateIP>
yum-config-manager --enable ol7_addons 
yum install docker-engine -y 
systemctl start docker 
systemctl enable docker
```
Add to the file in /etc/docker/daemon.json the code below and restart docker Daemon to Expose docker Metrics:
```
{
  "metrics-addr" : "0.0.0.0:9323",
  "experimental" : true
}
```

Now we can run the application by running the command below:
```
docker run -d -p 8080:8080  -it larocasdelcastillo/luis-oracle-dropwizard
```
The application will be accessible at: 
- ```http://<WebServerIP>/hello-world```
- ```http://<WebServerIP>/people```
  
You can interact with the application like this: ```curl -H "Content-Type: application/json" -X POST -d '{"fullName":"Luis Arocas","jobTitle":"DevOps"}' http://<WebServerIP>/people```
## Install Grafana and Prometheus for Monitoring
Create a prometheus config file prometheus.yml with the content below to pick up docker metrics:
```
scrape_configs:
  - job_name: 'docker'
    static_configs:
      - targets: ['docker-host:9323']
```
*Note:* To see the IP address of a docker container you can run this command: ```docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}'  <ContainerID>'''
Now run the Grafana and Prometheus Containers:
```
docker run -d -p 3000:3000 --name=grafana grafana/grafana-oss
docker run -d -p 9090:9090 -v /home/opc/prometheus.yml:/etc/prometheus/prometheus.yml quay.io/prometheus/prometheus
```
You will be able to access both Prometheus and Grafana at the links below:
- ```http://<GrafanaLBIP>/login```
- ```http://<PrometheusLBIP>/graph```

Log into Grafana and Add as Data Sources both Prometheus and Oracle Cloud Metrics.
