#!/bin/bash

set -e

STAGE=$1
if [ -z "$STAGE" ]; then
  echo "Usage: $0 <Stage: Dev|Prod>"
  exit 1
fi

CONFIG_FILE="config/${STAGE,,}_config"
if [ ! -f "$CONFIG_FILE" ]; then
  echo "Config file $CONFIG_FILE not found!"
  exit 1
fi

source "$CONFIG_FILE"

echo "Starting EC2 instance for $STAGE..."

INSTANCE_ID=$(aws ec2 run-instances \
  --image-id ami-0c02fb55956c7d316 \
  --count 1 \
  --instance-type $INSTANCE_TYPE \
  --key-name my-key-pair \
  --security-groups default \
  --user-data file://<(cat <<EOF
#!/bin/bash
yum update -y
amazon-linux-extras install java-openjdk$JAVA_VERSION -y
yum install git -y
cd /home/ec2-user
git clone $GIT_REPO
cd techeazy-devops
./mvnw spring-boot:run &
EOF
) --query 'Instances[0].InstanceId' --output text)

echo "Instance ID: $INSTANCE_ID"

echo "Waiting for instance to start..."
aws ec2 wait instance-running --instance-ids $INSTANCE_ID

PUBLIC_IP=$(aws ec2 describe-instances --instance-ids $INSTANCE_ID \
  --query 'Reservations[0].Instances[0].PublicIpAddress' --output text)

echo "Public IP: $PUBLIC_IP"
echo "Waiting 60 seconds for app to initialize..."
sleep 60

echo "Checking app on http://${PUBLIC_IP}:80"
curl -m 10 http://${PUBLIC_IP} || echo "App may not be available yet."

echo "Sleeping for ${RUN_DURATION}s before terminating..."
sleep $RUN_DURATION

echo "Terminating instance $INSTANCE_ID"
aws ec2 terminate-instances --instance-ids $INSTANCE_ID

echo "Waiting for termination..."
aws ec2 wait instance-terminated --instance-ids $INSTANCE_ID

echo "Instance terminated successfully."
