* lua学习笔记 
** basic
   print("10" + 1) =======> 11.0  amazing
   print("10 + 1") =======> 10+1
   
   first character of a string has index 1
   可变参数函数  fun( ... )
   通过table传递named arg
** TODO Exercise 
   eight-queen :
   most frequent words:
   read 《programming in lua》 part2
** advance
   table.concat拼接字符串 效率远高于 .. 
   利用goto模拟continue
   while c do
       if c then 
           goto continue
       else
           do something
       end
       ::continue:: 
   end
   tail call(尾调用) : return fun() end  不在stack保存调用fun的信息 空间复杂度O(1) 
   
   Entry{} == Entry({})   use dofile() read data from file save as table formated

   __index  lua单继承实现
   use __newindex make a table read-only
** hacking
   
* Cpp学习笔记
** basic
*** constexpr
   使用constexpr 而不是const来声明常量表达式
   const int *p = nullptr; //p是一个指向整型常量的指针
   constexpr int *p = nullprt; //p是一个指向整型的常量指针
*** TODO auto关键字可能会造成顶层const被忽略
*** TODO decltype 获取表达式的类型 
    decltype(f()) sum = x;
*** 类内初始值只能放在花括号里边或者等号右边  不能使用圆括号！！！
*** vector
    不存在包含引用的Vector
    c++11标准之前的vector<vector<int>> 需写出 vector<vector<int> > (注意右尖括号左边的空格)
    vector对象的下标可以用于访问 不能用于添加元素
**** 初始化
     1.在使用拷贝初始化（即 =）时,只能提供一个初始值
     2.如果提供的是一个类内初始值,只能使用拷贝初始化或者花括号形式的初始化
     3.如果提供的时初始值列表,只能使用花括号初始化
*** 比较运算符用于c风格字符串比较的是指针而不是字符串本身  必须用strcmp()方法进行比较

*** TODO array&& point
*** 后置递增/递减运算符的优先级高于解引用运算符
*** TODO 位运算符
*** TODO cast类型转换
** advance

** hacking

* Cocos2d-x学习笔记
** basic

** advance
*** 使用notificationNode 可以使一些东西独立于scene显示   (比如全局手柄之类的)
   	auto joystick = Joystick::create();
		joystick->setOpacity(150);
		Director::getInstance()->setNotificationNode(joystick);

** problems
*** don't have 64bit lib
    cocos compile -p android --ndk-mode debug --ndk-toolchain arm-linux-androideabi-4.9 --app-abi armeabi 

    You will need to replace the --ndk-toolchain to the proper one that comes with your NDK installation.
    Check in the toolchains folder inside NDK_ROOT.
    The most important one that actually got it working was --app-abi armeabi as that is what was the toolchain used.
    [Edit] If you actually check cocos compile -h you will see that --app-abi mentions armeabi as the default.
    But that is not the case. It is picking up arm64 as the default.

*** libfmod.so.6 not found    
    1) copy
    sudo cp <COCOS FOLDER LOCATION>/external/linux-specific/fmod/prebuilt/64-bit/libfmod.so /usr/local/lib/
    sudo cp <COCOS FOLDER LOCATION>/external/linux-specific/fmod/prebuilt/64-bit/libfmodL.so /usr/local/lib/

   2) create symbolic link in /usr/local/lib/
    ln -s libfmod.so libfmod.so.

   3) run ./install-deps-linux again


** hacking

* OpenGl学习笔记
** basic

** advance

** hacking

* Spacemacs配置记录
** layers
* Cmake
** command
* Git 
** command
   
** skill
*** delete commit 
    git log  -- get hash code to roll back
    git rest --head hashcode 

