. ./conf/vpc.conf
. ./lib/func.sh

echo "START createing VPC"

# VPC作成
VPC_ID_RET=$(
aws ec2 create-vpc \
  --cidr-block $VPC_CIDR_BLOCK \
  | jq -r '.Vpc.VpcId'
)

check_result $VPC_ID_RET

echo "START createing Subnet"

# サブネット作成
SUBNET_ID_RET=$(aws ec2 create-subnet --vpc-id $VPC_ID_RET \
  --cidr-block $SUBNET_CIDR_BLOCK \
  --availability-zone $AVAILABILITY_ZONE \
  | jq -r '.Subnet.SubnetId'
)


check_result $SUBNET_ID_RET

echo "START createing InternetGateway"

# インターネットゲートウェイの構築
IGW_ID_RET=$(
  aws ec2 create-internet-gateway | jq -r '.InternetGateway.InternetGatewayId'
)

check_result $IGW_ID_RET

echo "START attaching InternetGateway to the VPC"

# インターネットゲートウェイをVPCへ割り当てる
aws ec2 attach-internet-gateway \
  --vpc-id $VPC_ID_RET \
  --internet-gateway-id $IGW_ID_RET


echo "START creating Routetable"
# ルートテーブルの作成
ROUTETABLE_ID_RET=$(aws ec2 create-route-table --vpc-id $VPC_ID_RET \
  | jq -r '.RouteTable.RouteTableId'
)

check_result $ROUTETABLE_ID_RET
# ルートの作成
aws ec2 create-route --route-table-id $ROUTETABLE_ID_RET \
  --destination-cidr-block 0.0.0.0/0 \
  --gateway-id $IGW_ID_RET

# ルートの紐づけ パブリックサブネット
aws ec2 associate-route-table --route-table-id $ROUTETABLE_ID_RET \
  --subnet-id $SUBNET_ID_RET

# サブネットに起動されたインスタンスが自動的にパブリック IP アドレスを受け取るように
aws ec2 modify-subnet-attribute --subnet-id $SUBNET_ID_RET --map-public-ip-on-launch

EC2_SECURITY_GROUP_ID=$(aws ec2 create-security-group \
  --description  $SECURITY_GROUP_DESCRIPTION \
  --group-name $SECURITY_GROUP_DESCRIPTION \
  --vpc-id $VPC_ID_RET | jq -r .GroupId
)


# 22番ポートと80番ポートを解放
aws ec2 authorize-security-group-ingress \
  --group-id $EC2_SECURITY_GROUP_ID \
  --cidr '0.0.0.0/0' \
  --port 22 \
  --protocol tcp

aws ec2 authorize-security-group-ingress \
  --group-id $EC2_SECURITY_GROUP_ID \
  --cidr '0.0.0.0/0' \
  --port 80 \
  --protocol tcp

# 設定ファイルに設定を書き加える
echo "VPC_ID='${VPC_ID_RET}'" >> ./conf/vpc.conf
echo "SUBNET_ID='${SUBNET_ID_RET}'" >> ./conf/vpc.conf
echo "IGW_ID='${IGW_ID_RET}'" >> ./conf/vpc.conf
echo "ROUTETABLE_ID='${ROUTETABLE_ID_RET}'" >> ./conf/vpc.conf
echo "EC2_SECURITY_GROUP_ID='${EC2_SECURITY_GROUP_ID}'" >> ./conf/ec2.conf


# サービスごとに名前つける
aws ec2 create-tags  \
  --resources $VPC_ID_RET \
  --tags Key=Name,Value="${VPC_NAME}-vpc"

aws ec2 create-tags  \
  --resources $SUBNET_ID_RET \
  --tags Key=Name,Value="${VPC_NAME}-subnet"

aws ec2 create-tags  \
  --resources $IGW_ID_RET \
  --tags Key=Name,Value="${VPC_NAME}-igw"

aws ec2 create-tags  \
  --resources $ROUTETABLE_ID_RET \
  --tags Key=Name,Value="${VPC_NAME}-rtb"

aws ec2 create-tags  \
  --resources $EC2_SECURITY_GROUP_ID \
  --tags Key=Name,Value="${VPC_NAME}-sg"

