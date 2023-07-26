# Oracle Cloud Project

This project creates a WebServer for the Dropwizard project to run in Oracle Cloud. It also provisions all the necessary resources to support this project, such as Load Balancers, Bastion Server, Grafana, and Prometheus.

<img width="494" alt="image" src="https://github.com/larocas/oci-project/assets/139692500/b0b076d4-2df4-4aba-9779-55bfdacff935">

## Infrastructure development
To create the underlying infrastructure for this project:
```
# Clone this repository to your local machine:
git clone git@github.com:larocas/oci-project.git

# Set up the environment variables for OCI authentication:
export TF_VAR_tenancy_ocid=<YourValue>
export TF_VAR_user_ocid=<YourValue>
export TF_VAR_fingerprint=<YourValue>
export TF_VAR_private_key_path=<YourValue>

# Create the infrastructure using Terraform:
cd infrastructure
terraform init
terraform plan
terraform apply
```
## Application Development 

This project will run a Dropwizard Java application. The Dropwizard example application was developed to provide examples of some of the features present in Dropwizard. I will be following the documentation on [dropwizard-example](https://github.com/dropwizard/dropwizard/tree/master/dropwizard-example). To run the application:
1. Clone the Dropwizard repository:
```
git clone https://github.com/dropwizard/dropwizard.git
```
2. Build the Dropwizard example application:
```
mvn package -Dmaven.test.skip
cd dropwizard-example
java -jar target/dropwizard-example-$DW_VERSION.jar db migrate example.yml
java -jar target/dropwizard-example-$DW_VERSION.jar server example.yml
```
You can now access the Hello World example at (http://localhost:8080/hello-world)

## Dockerize the Application
Using the Dockerfile of this project and the jar file obtained in the previous step, create the Docker image and push it to Docker Hub:
```
docker login -u larocasdelcastillo
docker image build -t larocasdelcastillo/luis-oracle-dropwizard:latest .
docker push larocasdelcastillo/luis-oracle-dropwizard:latest
```
## Deploy the Application
First, SSH into the web server and install all necessary components to run Docker on the server:
```
scp -i opc.pem opc.pem opc@<BastionPublicIP>:~
ssh -i opc.pem opc@<BastionPublicIP>
ssh -i opc.pem opc@<WebServerPrivateIP>
yum-config-manager --enable ol7_addons 
yum install docker-engine -y 
systemctl start docker 
systemctl enable docker
```
Next, add the following code to the file /etc/docker/daemon.json to expose Docker metrics and restart the Docker Daemon:
```
{
  "metrics-addr" : "0.0.0.0:9323",
  "experimental" : true
}
```
Now you can run the application using the command below:
```
docker run -d -p 8080:8080  -it larocasdelcastillo/luis-oracle-dropwizard
```
The application will be accessible at: 
- ```http://<WebServerIP>/hello-world```
- ```http://<WebServerIP>/people```
  
You can interact with the application like this: ```curl -H "Content-Type: application/json" -X POST -d '{"fullName":"Luis Arocas","jobTitle":"DevOps"}' http://<WebServerIP>/people```
## Install Grafana and Prometheus for Monitoring
Create a Prometheus config file prometheus.yml with the following content to collect Docker metrics:
```
scrape_configs:
  - job_name: 'docker'
    static_configs:
      - targets: ['docker-host:9323']
```
*Note:* To see the IP address of a Docker container, you can run this command: ```docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}'  <ContainerID>```

Now run the Grafana and Prometheus Containers:
```
docker run -d -p 3000:3000 --name=grafana grafana/grafana-oss
docker run -d -p 9090:9090 -v /home/opc/prometheus.yml:/etc/prometheus/prometheus.yml quay.io/prometheus/prometheus
```
You will be able to access both Prometheus and Grafana at the links below:
- ```http://<GrafanaLBIP>/login```
- ```http://<PrometheusLBIP>/graph```

Log into Grafana and add both Prometheus and Oracle Cloud Metrics as data sources.

## Extra Development

Here's an example of coding the Fibonacci Series (The Fibonacci number is the summation of the two previous numbers in the series). One of the most common ways to implement it is using recursion:

- If n is not less than 1, then call recursively the previous two numbers.
- If n reaches 1, then return 1.

```
public class FibonacciSeries {
    public static int fibonacci(int n) {
        if (n <= 1) {
            return n;
        } else {
            return fibonacci(n - 1) + fibonacci(n - 2);
        }
    }
}
```
