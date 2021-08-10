# Terminates a given cluster, notifying it's user via email
# Requires a cluster to be tagged with "Owner_Name"
import boto3
import json
from botocore.config import Config

config = Config(
    retries = dict(
        max_attempts = 10
    )
)
emr_client = boto3.client('emr', 'us-east-1',config=config)
ses_client = boto3.client('ses', 'us-east-1')

def lambda_handler(event, context):
   
    messages_json = json.loads(event['Records'][0]['Sns']['Message'])
    cluster_id = messages_json['Trigger']['Dimensions'][0]['value']
    email_cc_recipients = ['qpp-final-scoring-devops@semanticbits.com']
    cluster_metadata = {}
    
    cluster_dict = emr_client.describe_cluster(
        ClusterId=cluster_id
    )
    
    for tag in cluster_dict['Cluster']['Tags']:
        cluster_metadata[tag['Key']] = tag['Value']
        
    if 'No_Termination' in cluster_metadata:
        return "Active Exemption_Code code found, don't terminate the cluster!"

    email_body ="<p>Hi " + cluster_metadata['Owner_Name'] + ",</p>" \
        + "<p>We are notifying you because you are the owner of Cluster <b>" +cluster_metadata['Name'] + "</b> "\
        + "which has been Idle for 1 Hour. " \
        + "</b> An alarm was triggered for your cluster, because its idle time exceeded the idle cluster threshold. (1 hours). " \
        + "<p>This alarm was caused because no <b><i>EMR step</i></b> or <b><i>Zeppelin(Spark) jobs</i></b> run in your cluster for 60 minutes.<p>" \
        + "<p><b>NOTE:</b> If any EMR step or Zeppelin task is running in your cluster, we will not terminate it!</p>" \
        + "<p>To prevent from incurring more AWS cost, " \
        + "your cluster is being terminated NOW. " \
        + "Please do note, it is your responsibility as an Engineer to terminate your cluster " \
        + "after you're done working on it.</p>" \
        + "<p>For any future work, please be advised of the usage and cost associated with it. " \
        + "We would really appreciate it if all engineers are responsible and take appropriate action " \
        + "to minimize the expenditures.</p>" \
        + "<p>Link to the cluster:-</br>" \
        + "<a href=\"https://console.aws.amazon.com/elasticmapreduce/home?region=us-east-1#cluster-details:" \
        + cluster_id + "\"> " + cluster_metadata['Name'] + "</a></p>" \
        + "<p>Thanks, </br>Final Scoring DevOps Team</p>"    
    
    emr_client.terminate_job_flows(
        JobFlowIds=[
            cluster_id,
        ]
    )
    
    response = ses_client.send_email(
        Source='qpp-final-scoring-devops@semanticbits.com',
        Destination={
            'ToAddresses': [
                cluster_metadata['Owner_Email']
            ],
            'CcAddresses': email_cc_recipients
        },
        Message={
            'Subject': {
                'Data'    : 'Alert: Idle EMR cluster terminated...',
                'Charset' : 'UTF-8'
            },
            'Body': {
                'Text': {
                    'Data'    : 'test email',
                    'Charset' : 'UTF-8'
                },
                'Html': {
                    'Data'    : email_body,
                    'Charset' : 'UTF-8'
                }
            }
        }
    )   
    
    return "success"

