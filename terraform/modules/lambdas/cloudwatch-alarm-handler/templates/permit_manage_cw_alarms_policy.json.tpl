{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "ManageClusters",
            "Effect": "Allow",
            "Action": [
                "elasticmapreduce:DescribeSecurityConfiguration",
                "elasticmapreduce:GetBlockPublicAccessConfiguration",
                "elasticmapreduce:ListSecurityConfigurations",
                "elasticmapreduce:ViewEventsFromAllClustersInConsole",
                "elasticmapreduce:ListClusters",
                "elasticmapreduce:ListEditors",
                "elasticmapreduce:GetManagedScalingPolicy",
                "elasticmapreduce:DescribeStep",
                "elasticmapreduce:ListInstances",
                "elasticmapreduce:ListBootstrapActions",
                "elasticmapreduce:ListSteps",
                "elasticmapreduce:ListInstanceFleets",
                "elasticmapreduce:ModifyCluster",
                "elasticmapreduce:DescribeCluster",
                "logs:CreateLogGroup",
                "elasticmapreduce:DescribeJobFlows",
                "elasticmapreduce:TerminateJobFlows",
                "elasticmapreduce:ListInstanceGroups",
                "ses:SendEmail"
            ],
            "Resource": [
                "arn:aws:logs:us-east-1:${account_id}:*",
                "arn:aws:elasticmapreduce:*:${account_id}:cluster/*"
            ]
        },
        {
            "Sid" : "ManageCloudwatch",
            "Effect": "Allow",
            "Action": [
                "cloudwatch:*"
            ],
            "Resource": "arn:aws:cloudwatch:us-east-1:${account_id}:alarm:*"
        }
    ]
}
