. ./conf/key.conf
. ./conf/ec2.conf

ssh -i ./conf/"${KEYNAME}.pem" ec2-user@$EC2_IP
