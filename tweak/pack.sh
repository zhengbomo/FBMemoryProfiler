CodeSigning="Apple Development: xxxxx (xxxxx)"

Project="FBMemoryProfiler"
Configuration="Debug"
# # 当前目录
WorkDir=$(pwd) 
# # build目录
BuildDir="${WorkDir}/build"

rm -rf $BuildDir

# 进入工程目录
cd ..

# 打包
xcodebuild -target "${Project}" -project "${Project}.xcodeproj" -configuration "${Configuration}" -sdk iphoneos BUILD_DIR="${BuildDir}" clean build;

# 删除无用文件
rm -rf "${BuildDir}/${Configuration}-iphoneos/${Project}.framework/Headers"
rm -rf "${BuildDir}/${Configuration}-iphoneos/${Project}.framework/Modules"
rm -rf "${BuildDir}/${Configuration}-iphoneos/${Project}.framework/PrivateHeaders"

# 签名
codesign -fs "${CodeSigning}" "${BuildDir}/${Configuration}-iphoneos/${Project}.framework"

# 拷贝到对应路径
if [ -d "${WorkDir}/layout/usr/lib/${Project}/${Project}.framework" ]; then
    rm -rf "${WorkDir}/layout/usr/lib/${Project}/${Project}.framework"
fi
cp -rf "${BuildDir}/${Configuration}-iphoneos/${Project}.framework" "${WorkDir}/layout/usr/lib/${Project}"


echo "完成"