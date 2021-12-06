. ./conf/ec2.conf
. ./conf/vpc.conf

aws ec2 terminate-instances --instance-ids $EC2_INSTANCE_ID
sleep 30
aws ec2 delete-security-group --group-id $EC2_SECURITY_GROUP_ID
aws ec2 delete-subnet --subnet-id $SUBNET_ID
aws ec2 delete-route-table --route-table-id $ROUTETABLE_ID
aws ec2 detach-internet-gateway --internet-gateway-id $IGW_ID --vpc-id $VPC_ID
aws ec2 delete-internet-gateway --internet-gateway-id $IGW_ID
aws ec2 delete-vpc --vpc-id $VPC_ID


aws ec2 delete-key-pair --key-name $KEYNAME
rm -f ./conf/$KEYNAME.pem

sed -i -e '/EC2_SECURITY_GROUP_ID/d' ./conf/ec2.conf
sed -i -e '/EC2_INSTANCE_ID/d' ./conf/ec2.conf
sed -i -e '/EC2_IP/d' ./conf/ec2.conf
sed -i -e '/EC2_INSTANCE_NAME/d' ./conf/ec2.conf
sed -i -e '/VPC_ID/d' ./conf/vpc.conf
sed -i -e '/SUBNET_ID/d' ./conf/vpc.conf
sed -i -e '/IGW_ID/d' ./conf/vpc.conf
sed -i -e '/ROUTETABLE_ID/d' ./conf/vpc.conf


echo "DELETE VPC AND INSTANCE DONE"
