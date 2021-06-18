# lacework_fargate
Lacework Deployment mechanisms for Fargate

Two important components here.  Currently the testing from this repository has been done against a specifically built container of the lw-sidecar.  Dockerfile for that is available in lw-sidecar/dockerfile.

Secondly, this is all test code and if you're reading this, presumably you know the author in some fashion and that should be all the reason you need to proceed with caution.  There are no warranties, express or implied in this repository.

Thirdly, (see I can't even count properly, how do you trust me on anything?) the current documentation is in the ecs/eks_fargate.txt files, because I wrote this from a windows machine.

Did I make the point well enough this code is not to be trusted?  Good.



Fundamentally, there is no specific difference between ECS and EKS fargate in how a given container runs.  To that end, this repository provides a sidecar based deployment method for EKS Fargate clusters and the lacework datacollector.
The important components are:
1) get the lacework datacollector binaries into your application container via a volumemount.
2) Run the datacollector first, so it can monitor the application process.
3) ???
4) Profit.
