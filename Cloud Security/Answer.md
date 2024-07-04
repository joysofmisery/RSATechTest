## Define network ACLs
- Network ACL is predominantly AWS concept, network access control list is set of rules which allow acess control. In AWS network ACL is applied on subnet. ACL has capablity to restric access based on port, protocols and source IP address. 
- In Azure network security groups have the same capablity, we can attach network security group on subnet level as well as on instance or VM level. When we use ACL on instance level in AWS, AWS classify them as security groups.

## Define Routes (Application connection)
- Routes are way to define path for traffic between networks. In Azure sysytem route tables are already created and attached each subnet, we do not need any specific route to allow communication within the internet and to internet.
- However if we have firewall or VPN gateway we might need custonm routes. These are called user defined route(UDR) and UDR take precedence over system routes.
## Azure Bastion/ Jump Server
- A jump server help to connect private server via a public endpoint. User connect with public endpoint and jump/hop to private vm i.e. from jump box connecting to private vm.
- Azure Bastion is a managed jump box service wich comprises of Vm scalset and a standard public IP. Since bastion consist of VM scaleset the public IP is associcated with load balancer.
- Azure bastion helps me to connect my VM securely via azure portal.
## Azure Function App 
Azure function app is a serverless event driven service (but can run withn a app service plan).
There are multiple ways by which we can trigger function app
- HTTP trigger
- Time trigger
- eventhub trigger
- servicebus trigger
- blob trigger

## Simple “Hello World” App to access
https://amitpy.azurewebsites.net/api/test1