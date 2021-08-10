{
    "Version": "2012-10-17",
    "Statement": [
       {
            "Sid": "AllowReadAccessToBucket",
            "Action": "s3:*",
            "Effect": "Allow",
            "Resource": [
                "arn:aws:s3:::${logging_bucket_name}",
                "arn:aws:s3:::${logging_bucket_name}/*",
                "arn:aws:s3:::${ingress_bucket_name}",
                "arn:aws:s3:::${ingress_bucket_name}/*",
                "arn:aws:s3:::aws-athena*",
                "arn:aws:s3:::us-east-1.elasticmapreduce/*"
            ]
        },
        {
            "Effect": "Allow",
            "Resource": "*",
            "Action": [
                "athena:*",
                "cloudwatch:*",
                "ec2:Describe*",
                "ec2:AssignPrivateIpAddresses",
                "ecr:GetAuthorizationToken",
                "ecr:BatchGetImage",
                "ecr:GetDownloadUrlForLayer",
                "elasticmapreduce:Describe*",
                "elasticmapreduce:ListBootstrapActions",
                "elasticmapreduce:ListClusters",
                "elasticmapreduce:ListInstanceGroups",
                "elasticmapreduce:ListInstances",
                "elasticmapreduce:ListSteps",
                "elasticmapreduce:AddJobFlowSteps",
                "glue:*",
                "rds:Describe*",
                "sdb:*",
                "sns:*",
                "sqs:*",
                "ssm:UpdateInstanceInformation"
            ]
        }
    ]
}
