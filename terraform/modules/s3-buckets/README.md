Will create unique buckets for each environment.

It is intended that bucket policies are created as part of this module. So there is the expectation that we need to likely add variables for who or what should should be allowed to access the bucket. In the case of the ingress bucket for example, we are passing in Role arns which are generated from the IAM module.