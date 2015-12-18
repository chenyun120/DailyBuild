#!/bin/sh
# CY
# 1.0
# 2015.12.16
# chenyun120@126.com
# 脚本同.xcodeproj 与同级目录下  

echo "查看是否存在ipa和Payload文件夹"

myIpa=~/ipa
myPayload=~/ipa/Payload

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
echo "打包成ipa完毕, 开始上传蒲公英"
curl -F "file=@$paths.ipa" -F "uKey=这里替换蒲公英ukey" -F "_api_key=这里替换蒲公英apiKey" -F "publishRange=3" -F "isPublishToPublic=2" -F "password=123456" http://www.pgyer.com/apiv1/app/upload > ~/ipa/response.txt
echo "开始上传完毕"

echo "处理网络请求结果"

varible=$(cat ~/ipa/response.txt)

str=${varible##*appQRCodeURL}

strTwo=${str%'"'*}

strThree=${strTwo:3-start}

endStr=${strThree##*'/'}

echo "打开网页"
open http://www.pgyer.com/$endStr
echo "已打开"
open .
