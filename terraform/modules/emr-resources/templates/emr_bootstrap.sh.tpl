#!/bin/bash

set -eux -o pipefail

# Copy dev's SSH keys down
# And add them to the hadoop users's authorized_keys
aws s3 cp s3://${ingress_bucket_name}/config/common/dev_ssh_keys.txt /tmp
cat /tmp/dev_ssh_keys.txt >> ~/.ssh/authorized_keys
