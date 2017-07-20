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

## 用Photoshop自动创建CocosStudio .csd文件

### 工具介绍

用Photoshop自动创建CocosStudio场景（Scene/Layer/Node）的工具，是：LayersToCSD.jsx（点击下载），这是一个photoshop脚本文件，安装和使用非常方便，这个photoshop脚本，改编自Spine的LayersToPNG.jsx脚本，只是修改了里面的文件输出部分和增加了一个.csb类型选择，所以会看到操作界面基本是相同的。


这个工具的调试用的是：Adobe Photoshop CS6，其它版本没测试过。

输出的csd文件格式为Cocos Studio 2的v2.1.5版本，其它版本没测试过。


### 安装

安装非常简单，只要下载LayersToCSD.jsx（点击下载），然后把文件放到photoshop的‘Scripts’目录就可以了。

photoshop的‘Scripts’目录详细路径：photoshop安装盘\photoshop文件夹\Presets\Scripts\。


### 使用

使用非常简单，只要两步：

1. 在photoshop中，打开要输出的文件，选择photoshop的‘文件’菜单，再选择‘脚本’子菜单就可以看到‘LayersToCSD’这个子菜单，点击，弹出操作窗口，如果没什么修改，直接点‘ok'按钮。
2. 把上一步生成的.csd文件和images文件，拖拽到Cocos Studio 2编辑器已打开的工程。

### 附加信息

默认输出的.csb类型为Scene，在弹出窗口的Type下拉框，可以选择：Scene/Layer/Node，分别对应.csb的Scene/Layer/Node。

photoshop画布大小要和Cocos Studio 2场景编辑器中的画布大小相同？？？不然会出现拉伸变形？？？这个没实际测试。

因为要在photoshop中，把每个层转换为图片存储到磁盘，这个操作会慢一些，在开始执行后，稍等一下，会看到在photoshop中出现一些额外的操作窗口，等这些额外的操作窗口，自动执行完全部操作，并自动关闭，转换就全部结束了，如果都是按默认操作执行，可以到.psd文件存放目录，看到新增加了一个.csd文件和一个images文件夹（这个操作都是自动操作，不用干预）。
用这个工具生成的.csd文件，‘NodeObjectData’都为’SpriteObjectData‘，如果能在Cocos Studio 2中可视化修改对象类型就方便多了。
如果想测试工具方便性，手头又没有.psd文件，提供了一个测试文件：skills.psd（点击下载），这个文件来自网络免费资源。
这个工具可以完善的地方比较多，比如美术人员在photoshop设计好以后，执行脚本，可以直接打开Cocos Studio 2看在编辑器效果，不过没什么实用价值，让美术额外装一个比较难用的Cocos Studio 2，还是放弃吧。
这个工具可以完善的地方比较多，比如可以在photoshop的Layer增加些关键字，可以直接用工具生成Cocos Studio 2编辑器用到的‘按钮’、‘复选框、‘输入框’等控件，让美术做额外的工作，貌似也不太好，放弃。
这个工具不支持中文，因为Spine的LayersToPNG.jsx脚本就不支持，哈哈。
如果没有在弹出窗口设置.csb文件名，这个工具根据.psd的文件名，生成.csd的文件名。
这个工具根据photoshop中Layer的名字，来生成图片的名字，所以这个要策划先把命名规则给美术沟通好，游戏用图的命名规则，就是photoshop中Layer的命名规则，因为不支持中文，所以如果photoshop中Layer名为中文，那么最终输出的图片名为乱码？？？

### 编译报错libcurl.a: No such file or directory   

删除Application.mk中的APP_SHORT_COMMANDS := true
