# Azure Infrastructure Operations Project: Deploying a scalable IaaS web server in Azure

### Introduction
For this project, you will write a Packer template and a Terraform template to deploy a customizable, scalable web server in Azure.

### Getting Started
1. Clone this repository
2. Get some orientation on the files
* 'image_build' contains files for the packer image
* 'ops' contains all infranstructure deployment code
3. Verify installation of below dependencies, collect your azure subscription id from the portal or CLI and start with the instructions below.

### Dependencies
1. Create an [Azure Account](https://portal.azure.com) 
2. Install the [Azure command line interface](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli?view=azure-cli-latest)
3. Install [Packer](https://www.packer.io/downloads)
4. Install [Terraform](https://www.terraform.io/downloads.html)

### Instructions
#### Install policy
1. navigate to 'ops' folder
2. authentication to Azure CLI with your preferred method.
3. Install Policy definition by 'az policy definition create --name tagging-policy --rules azure-tag-policy.json'
4. Assign policy to your subscription by 'az policy assignment create --policy tagging-policy'
5. You can verify now you newly assigne policy by 'az policy assignment list'
#### Building Packer Image
1. navigate to packer file directory 'image_build'
2. decide on authentication option for packer. Easiest way is to use device authentication. For this you only need to provide a subscription id (will be used in below step). Alternatively you can go for AAD interactive login, Azure Managed Identity, AAD Service Principal or Azure CLI. For details please refer to official [docs](https://www.packer.io/docs/builders/azure).
3. Ensure you have a resource group setup in Azure you want to save the image to.
4. build your packer image by 'packer build -var=subscription_id=YOUR_SUBSCRIPTION_ID -var=rg=RESOURCE_GROUP -var=image_name=IMAGE_NAME server.json'.
5. Verify your build image in the Azure CLI by 'az image list -g RESOURCE_GROUP'. Copy the value in "id" for your image as we need this for deployment later.

#### Deploy your infrastructure
1. navigate to 'ops/terraform/' folder
2. init terraform by 'terraform init'
3. check the variables.tf file. You will get prompted only for the image id you get in the previous packer build instructions. If you want to change something else you can edit the default values in the 'variables.tf' file.
4. verify the plan terraform wants to execute by 'terraform plan' in the directory
5. apply plan by 'terraform apply'. You will get prompted for the azure image id (you can also permanently add this as default in variabels.tf).
6. you should get two outputs presented 'lb_fqdn' and 'lb_ip_address' you can use both addresses to enter them in a web browser and check the deployment.
7. destroy your terraform deployment by 'terraform destroy'

### Output

#### Policy
You have now a policy applied to your description that is named 'tagging-policy' that prevents you to create resources without taggin them. This does not apply to existing resources (but you might not be able to edit them).

#### Packer Image
You get a build packer image in the specified resource group with the specified name that can be used to deploy VMs. The image has a simple nginxy running up from deployment that server a simple text file with "Hello World!". You can check the image in the Azure CLI or in the Portal. The image listens on port 81 for the custom page (on 80 the regulat nginx is running).
Be aware that packer is stateless and you must delete the image manually to avoid costs for storage. 

#### LB Deployment
You get a loadbalanced application that serves the build packer image with the simple web page. This can be accessed through the output FQDN or IP of the load balance in front. All resources are tagged with the project value. You can even after deployment increase the number of nodes in the variables.tf file and apply again to scale the application.
The build infrastructure should look high level like this:
1. Resource Group hosting all elements
2. Load Balancer
* Azure load balancer with a public IP and FQDN
* Simple LB rule that forwards all traffic from port 80 to 81 with a primitive probe that checks availability of backend nodes.
* Backend Address Pool that the VMs are assigned to.
3. Virtual Network
* Virtual network with one subnet that hosts the NICs of the VMs.
* Network Security Group with rules that block direct inbound traffic (except via LB) and allow intra subnet configuration. The Azure defaults are not overwritten. The NSG is applied to the subnet.
4. VM Availability Set
* defined amount of VMs in the availability set based on the created packer image
* attached data disks with 2G storage
* NIC that are connected to the subnet
* assignments to backend pool of load balancer



