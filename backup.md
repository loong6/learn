## vs 插件 

Reshaper C++、Viasfora、Indent Guides Mod、GhostDoc、CodeRush、Supercharger、ColorfulIDE

## cocos使用预编译库新建工程 

 http://blog.csdn.net/crocodile__/article/details/51133835
 
## 自动添加源文件

MY_CPP_LIST := $(wildcard $(LOCAL_PATH)/*.cpp)
MY_CPP_LIST += $(wildcard $(LOCAL_PATH)/hellocpp/*.cpp)
MY_CPP_LIST += $(wildcard $(LOCAL_PATH)/../../../Classes/*.cpp)

## Cocos2d-x下Lua调用自定义C++类和函数的最佳实践

http://blog.csdn.net/peoplezhou/article/details/43307679

## cocos2d-x调用摄像头和相册并裁减图片

http://blog.csdn.net/xjw532881071/article/details/50441651

## Cocos2dx-- 资源热更新

http://blog.csdn.net/u010223072/article/details/49073511

## git提取出两个版本之间的差异文件并打包

git diff 608e120 4abe32e --name-only | xargs zip update.zip

## 编译报错libcurl.a: No such file or directory   

删除Application.mk中的APP_SHORT_COMMANDS := true
