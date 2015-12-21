#!/bin/sh
# CY
# 1.0
# 2015.12.16
# chenyun120@126.com
# 脚本同.xcodeproj 与同级目录下  

myIpa=~/ipa
myPayload=~/ipa/Payload

pgyerUKey='这里替换蒲公英ukey'  # 这里替换蒲公英ukey
pgyerApiKey='这里替换蒲公英apiKey' # 这里替换蒲公英apiKey

echo "1. fir"
echo "2. pgyer"
printf "选择上传地点, 输入数字:"
read isPgyer

# ============= 实现fir后  删除这代码

if [ $isPgyer != 2 ]; then
	echo "功能未实现"
	exit
fi

# ==============

echo "查看是否存在ipa和Payload文件夹"

if [ ! -x "$myIpa" ]; then
echo "不存在ipa文件夹，开始创建"
mkdir "$myIpa"
echo "创建ipa文件夹完毕"
fi

if [ ! -x "$myPayload" ]; then
echo "不存在Payload文件夹，开始创建"
mkdir "$myPayload"
echo "创建Payload文件夹完毕"
fi

# 获取当前的文件夹名称
varible=$(pwd)
paths=${varible##*/}

echo "开始打包"
xcodebuild -configuration Release
echo "打包完毕"
echo "删除原先app包"
rm -rf ~/ipa/Payload/*.app
echo "删除原先app包完毕"
echo "复制app到新文件内"
cp -r Build/Release-iphoneos/$paths.app ~/ipa/Payload/
cd ~/ipa/
echo "复制完毕"
echo "删除原先ipa包"
rm -rf ~/ipa/*.ipa
echo "删除原先ipa包完毕"
cd ~/ipa/
echo "进入app所在路径"
echo "打包成ipa"
zip -r $paths.ipa *

if [ $isPgyer == 2 ]; 
then
echo "打包成ipa完毕, 开始上传蒲公英"
curl -F "file=@$paths.ipa" \
	 -F "uKey=$pgyerUKey" \
	 -F "_api_key=$pgyerApiKey" \
	 -F "publishRange=3" \
	 -F "isPublishToPublic=2" \
	 -F "password=123456" \ 
	 http://www.pgyer.com/apiv1/app/upload > ~/ipa/response.txt

echo "开始上传完毕"

echo "处理网络请求结果"

varible=$(cat ~/ipa/response.txt)
str=${varible##*appQRCodeURL}
str=${str%'"'*}
str=${str:3-start}
endStr=${str##*'/'}

echo "打开网页"
open http://www.pgyer.com/$endStr
echo "已打开"

else
echo "打包成ipa完毕, 开始上传fir"
curl -F "file=@$paths.ipa" \
	 -F "Key=" \
	 -F "token=a59ce75f51914a0b74d5a5d0d51fab25" \
	 -F "x:name=$paths" \
	 -F "x:version=1.0" \
	 -F "x:build=test.com" \ 
	 http://api.fir.im/upload_url > ~/ipa/response.txt
fi

open .
