#!/bin/bash
# This script generate app/public/data/regular.csv from the undocumented Amazon's json  price API.

# Create a tempory file where we will store data 
csvtmp=$(mktemp)

# Generate the linux part:
curl -s  http://aws.amazon.com/ec2/pricing/json/linux-od.json |jq -c '.config.regions[]'|while read regionline; do 
	regiontmp=$(echo $regionline|sed -e 's/valueColumns/\n\r/g' |grep region|sed -e 's/.*region\":\"//g' -e 's/\".*//g');
	case "$regiontmp" in
		us-east) 
			region="us-east-1"
			;;
		us-west-2)
			region="us-west-2"
			;;
		us-west)
			region="us-west-1"
			;;
		eu-ireland)
			region="eu-west-1"
			;;
		apac-sin)
			region="ap-southeast-1"
			;;
		apac-tokyo)
			region="ap-northeast-1"
			;;
		apac-syd)
			region="ap-southeast-2"
			;;
		sa-east-1)
			region="sa-east-1"
			;;
		*)
			echo -e "\n\r WTF: $regiontmp is unknow"
			exit 99
			;;
	esac
	echo $regionline|sed -e 's/valueColumns/\n\r/g' |grep name |cut -f1-3 -d,|while read nameline; do
		ostype=$(echo $nameline|sed -e 's/,\"/\n\r/g'|grep name|cut -f2 -d: |sed -e 's/^\"//g' -e 's/\".*//g');
		size=$(echo $nameline|sed -e 's/,\"/\n\r/g'|grep size|cut -f2 -d: |sed -e 's/^\"//g' -e 's/\".*//g');
		price=$(echo $nameline|sed -e 's/,\"/\n\r/g'|grep prices|cut -f4 -d: |sed -e 's/^\"//g' -e 's/\".*//g');
		echo $region.$ostype.$size,$price >> $csvtmp;
	done;
done

# Generate the windows part:
curl -s  http://aws.amazon.com/ec2/pricing/json/mswin-od.json |jq -c '.config.regions[]'|while read regionline; do 
	regiontmp=$(echo $regionline|sed -e 's/valueColumns/\n\r/g' |grep region|sed -e 's/.*region\":\"//g' -e 's/\".*//g');
	case "$regiontmp" in
		us-east) 
			region="us-east-1"
			;;
		us-west-2)
			region="us-west-2"
			;;
		us-west)
			region="us-west-1"
			;;
		eu-ireland)
			region="eu-west-1"
			;;
		apac-sin)
			region="ap-southeast-1"
			;;
		apac-tokyo)
			region="ap-northeast-1"
			;;
		apac-syd)
			region="ap-southeast-2"
			;;
		sa-east-1)
			region="sa-east-1"
			;;
		*)
			echo -e "\n\r WTF: $regiontmp is unknow \n\r"
			exit 99
			;;
	esac
	echo $regionline|sed -e 's/valueColumns/\n\r/g' |grep name |cut -f1-3 -d,|while read nameline; do
		ostypetmp=$(echo $nameline|sed -e 's/,\"/\n\r/g'|grep name|cut -f2 -d: |sed -e 's/^\"//g' -e 's/\".*//g');
		case "$ostypetmp" in
			linux)
				ostype="linux"
				;;
			mswin)
				ostype="windows"
				;;
			*)
				echo -e "\n\r WTF: $ostypetmp is unknow \n\r"
				exit 98
				;;
		esac 
		size=$(echo $nameline|sed -e 's/,\"/\n\r/g'|grep size|cut -f2 -d: |sed -e 's/^\"//g' -e 's/\".*//g');
		price=$(echo $nameline|sed -e 's/,\"/\n\r/g'|grep prices|cut -f4 -d: |sed -e 's/^\"//g' -e 's/\".*//g');
		echo $region.$ostype.$size,$price >> $csvtmp;
	done;
done

# Remplace regular.csv
mv $csvtmp app/public/data/regular.csv
