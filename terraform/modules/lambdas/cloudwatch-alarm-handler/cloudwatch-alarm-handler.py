# Creates a cloudwatch alarm when it sees a cluster state == 'STARTING'
# Deletes the alarm if it sees the cluster state ==  'TERMINATED', 'TERMINATED_WITH_ERRORS'
# Alarms are sent to jmp-test-sns for another lambda to pick up & terminate the cluster
import boto3
from botocore.config import Config

config = Config(
    retries = dict(
        max_attempts = 10
    )
)

emr_client = boto3.client('emr', 'us-east-1',config=config)
ses_client = boto3.client('ses', 'us-east-1')
cw_client  = boto3.client('cloudwatch')

def lambda_handler(event, context):
    print(event)
    cluster_name  = event['detail']['name']
    cluster_id    = event['detail']['clusterId']
    cluster_state = event['detail']['state']
    
    if cluster_state == "STARTING":   
        response = cw_client.put_metric_alarm(
            AlarmName= cluster_id + '-idle-for-60-minutes',
            AlarmDescription='This alarm monitors '+ cluster_name + ' cluster is idle for 60 minutes',
            AlarmActions=[
                'arn:aws:sns:us-east-1:${data.aws_caller_identity.current.account_id}:clusters-idle-for-an-hour'
            ],
            MetricName='IsIdle',
            Namespace='AWS/ElasticMapReduce',
            Statistic='Average',
            Period=300,
            Dimensions=[ 
                {
                    'Name': 'JobFlowId',
                    'Value': cluster_id
                }
            ],
            EvaluationPeriods=13,
            DatapointsToAlarm=13,
            Threshold=1,
            ComparisonOperator='GreaterThanOrEqualToThreshold',
            TreatMissingData='notBreaching'
        )
    elif cluster_state in ['TERMINATED', 'TERMINATED_WITH_ERRORS']:
        response = cw_client.delete_alarms(
            AlarmNames=[
                cluster_id + '-idle-for-60-minutes'
            ]
        )
    
    return event
