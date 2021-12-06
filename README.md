# easyVPC
簡単にvpcとec2を立てるスクリプト
[やり方](https://qiita.com/nobu_wt/private/886455382d9c7d83a1fd)はQiitaにも載せてます

# 1. はじめに

- 秘密鍵もVPCもEC2も簡単につくってくれるシェルスクリプト
- AWS CLI のコマンドを列挙してる
- 設定ファイルにネットワークに関するパラメータを埋めて、順番にスクリプトを実行する

このスクリプトで作れるものはこの図のとおり。
![adventCalendar.jpg](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/735845/6a8a02b5-432a-b3b1-4377-8945bec79051.jpeg)

## 環境
必要なもの: jq, AWS CLI

jqコマンドのインストール方法:

https://stedolan.github.io/jq/download/

AWS CLIのインストール方法:

https://docs.aws.amazon.com/ja_jp/cli/latest/userguide/install-cliv2.html

## 3. vpcのネットワーク設定を書き込む

例.)
```conf/vpc.conf
AVAILABILITY_ZONE='ap-northeast-1a'
VPC_CIDR_BLOCK='192.168.10.0/27'
SUBNET_CIDR_BLOCK='192.168.10.0/28'
VPC_NAME='adventcalendar'
SECURITY_GROUP_DESCRIPTION='web-server'
```

## 3. EC2の設定を書き込む
無料枠で使いたい人はこのままで大丈夫です、amiはamazon linux2を指定しています。  
他のを使いたい方は[公式のLinux/ AMI の検索](https://docs.aws.amazon.com/ja_jp/AWSEC2/latest/UserGuide/finding-an-ami.html)を参考にしてください。

```conf/ec2_conf.sh
. ./conf/key.conf

EC2_IMAGE_ID='ami-0218d08a1f9dac831'
EC2_INSTANCE_TYPE='t2.micro'
KEY_NAME=$KEYNAME

```

## 4. 秘密鍵の生成
conf/key.confに秘密鍵の名前を英字で入力してください

```conf/key.conf
KEYNAME='Name'
```

設定できたら次のコマンドで秘密鍵を生成します。

```
sh key_create.sh
```

するとconfディレクトリの中に秘密鍵が生成されます。

	

## 5. VPCの作成
vpc_create.shを実行してください。

```
sh vpc_create.sh
```

するとjsonでレスポンスが返ってくるはずです。
もし、エラーが返ってきた場合は、conf/vpc.confのネットワーク設定が間違っているということなので、conf/vpc.confを見直しましょう。

## 6. EC2の作成
ec2_create.shを実行してください。

```
sh ec2_create.sh
```

## 7. sshでインスタンスに入る
ssh.shを実行しましょう。

```
sh ssh.sh
```

そうすると、
Are you sure you want to continue connecting (yes/no/[fingerprint])? 
と聞かれるので
yes
とタイプしEnterを押して先に進みましょう。


## VPCもインスタンスもまとめて削除
少し時間がかかるのは意図的です。インスタンスが終了するのを待っています。
```
sh delete.sh
```



## 参考記事

https://docs.aws.amazon.com/ja_jp/vpc/latest/userguide/vpc-subnets-commands-example.html

https://genzouw.com/entry/2019/03/04/123533/1077/

https://www.isoroot.jp/blog/3188/

https://docs.aws.amazon.com/ja_jp/AWSEC2/latest/UserGuide/finding-an-ami.html

