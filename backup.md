# vs 插件 

Reshaper C++、Viasfora、Indent Guides Mod、GhostDoc、CodeRush、Supercharger、ColorfulIDE

# cocos使用预编译库新建工程 

 http://blog.csdn.net/crocodile__/article/details/51133835
 
# 自动添加源文件

MY_CPP_LIST := $(wildcard $(LOCAL_PATH)/*.cpp)
MY_CPP_LIST += $(wildcard $(LOCAL_PATH)/hellocpp/*.cpp)
MY_CPP_LIST += $(wildcard $(LOCAL_PATH)/../../../Classes/*.cpp)
