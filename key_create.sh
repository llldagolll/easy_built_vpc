. ./conf/key.conf

aws ec2 create-key-pair --key-name $KEYNAME --query 'KeyMaterial' --output text > ./conf/$KEYNAME.pem \
  && chmod 400 ./conf/$KEYNAME.pem


echo "CREATE KEY DONE"
