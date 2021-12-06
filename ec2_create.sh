. ./conf/ec2.conf
. ./conf/vpc.conf
. ./conf/key.conf


EC2_INSTANCE_ID=$(aws ec2 run-instances \
  --image-id $EC2_IMAGE_ID \
  --count 1 \
  --instance-type $EC2_INSTANCE_TYPE \
  --security-group-ids $EC2_SECURITY_GROUP_ID \
  --key-name $KEYNAME \
  --subnet-id $SUBNET_ID \
  | jq -r '.Instances[0].InstanceId'
)

sleep 2

EC2_IP=$(aws ec2 describe-instances --instance-id $EC2_INSTANCE_ID \
  | jq -r '.Reservations[0].Instances[0].PublicIpAddress'
)

echo "EC2_INSTANCE_ID='${EC2_INSTANCE_ID}'" >> ./conf/ec2.conf
echo "EC2_IP='${EC2_IP}'" >> ./conf/ec2.conf
echo "EC2_INSTANCE_NAME='${VPC_NAME}-instance'" >>./conf/ec2.conf

aws ec2 create-tags  \
  --resources $EC2_INSTANCE_ID \
  --tags Key=Name,Value="${VPC_NAME}-instance"

echo "DONE"
