##EMR Cluster Management Scripts##

This directory contains the terraform & source to manager our EMR clusters
*This has been moved to a module as part of the account migration so we can support having multiple AWS accounts*
###Cloudwatch Handler:###
* Creates a Cloudwatch Alarm for each cluster. The alarm goes RED if the cluster "isIdle" for an hour (checked every 5 min), triggering a second lambda to terminate the idle cluster
* Deletes the alarm if a cluster is terminated

###Cluster Termination:###
* Listens to the SNS topic that's source is the CloudWatch Alarm mentioned above
* Shuts down EMR clusters & emails the owner


