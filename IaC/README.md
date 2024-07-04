# Introduction 
This code address the RSA challenge. This is challenge no 2 IaC (Infra structure as code). This challenge ask to deploy network of a typical 3-tier arch.




### Resources
This code deployes following resources:-
- vnet - Virtual network for a 3-teir arch.
- subnet - the code deployes 4 subnet
    1. frontend - Assuming VM deployed in this subnet have public IP. NAT gateway is not attached to this subnet
    2. backend -- Nat gateway attached to this subnet.
    3. DB
    4. Bastion - This is created as part of problem 5. 
- NatGateway - A fixed public IP for secure public outbound connectivity.
- NATGateway public IP
- NSG (Network security group) - 3 NSG deployed
    1. frontend - allowing access from 111.111.111.111 over HTTPS only.
    2. Backend - Allowing only vnet traffic and all public inbound is blocked.
    3. DB - only vnet traffic allowed.


