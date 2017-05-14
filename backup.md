# vs 插件 

Reshaper C++、Viasfora、Indent Guides Mod、GhostDoc、CodeRush、Supercharger、ColorfulIDE

# cocos使用预编译库新建工程 

 http://blog.csdn.net/crocodile__/article/details/51133835
 
# 自动添加源文件

define walk
$(wildcard $(1)) $(foreach e, $(wildcard $(1)/*), $(call walk, $(e)))
endef

ALLFILES = $(call walk, $(LOCAL_PATH)/../../Classes)
FILE_LIST := hellocpp/main.cpp

FILE_LIST += $(filter %.cpp, $(ALLFILES))

LOCAL_SRC_FILES := $(FILE_LIST:$(LOCAL_PATH)/%=%)

