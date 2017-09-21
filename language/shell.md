# shell  学习笔记
> 参考自[Shell 变量 | 菜鸟教程](http://www.runoob.com/linux/linux-shell-variable.html)

## 基础知识
> Shell 是一个用 C 语言编写的程序，它是用户使用 Linux 的桥梁。Shell 既是一种命令语言，又是一种程序设计语言。
Shell 是指一种应用程序，这个应用程序提供了一个界面，用户通过这个界面访问操作系统内核的服务。
Ken Thompson 的 sh 是第一种 Unix Shell，Windows Explorer 是一个典型的图形界面 Shell。
### 第一个脚本
```shell
#!/bin/bash
echo "hello World!"
```
*\#!是一个约定的标记，它告诉系统这个脚本需要什么解释器来执行，即使用哪一种Shell.*	
*echo 命令用于向窗口输出文本.*

## 变量   
定义变量是,变量符号不加$，如  

```shell
your_name="test"
```

注意，变量名和等号之间不能有空格，这可能和你熟悉的所有编程语言都不一样。同时，变量名的命名须遵循如下规则：	
1. 首个字符必须为字母（a-z，A-Z)	
2. 中间不能有空格，可以使用下划线（_)	
3. 不能使用标点符号		
4. 不能使用bash里的关键字（可用help命令查看保留关键字）

除了显式地直接赋值，还可以用语句给变量赋值，如：

```shell
for file in `ls /etc`
```

以上语句将/etc下目录的文件名遍历输出

使用定义过的变量时要使用$,如下：   

```shell
your_name="test"
echo $your_name
echo ${your_name} #变量名外面的花括号是可选的，加不加都行，加花括号是为了帮助解释器识别变量的边界
```

已定义的变量 可以重新定义 如：

```shell
your_name="tom"
echo ${your_name}
your_name="toms"
echo ${your_name}

readonly your_name #将变量标识为只读
unset your_name #删除变量  但不能删除只读的变量
```

### 变量的类型   

1. 局部变量：当前脚步中定义的变量  
2. 环境变量：
3. shell变量： 

### shell字符串    

字符串是shell编程中最常用最有用的数据类型，字符串可以用单引号、双引号、甚至不用引号。   
单引号字符串的限制：

- 单引号里的任何字符都会原样输出，单引号字符串中的变量是无效的；
- 单引号字符串中不能出现单引号（即使转义也不行）

**双引号字符串中可以有变量和转义字符出现**

### 拼接字符串   

```shell
your_name="qinjx"
greeting="hello, "${your_name}"!"
greeting="hello, ${your_name}!"
echo $greeting $greeting_1
```

### 获取字符串长度

```shell
string="nothing"
echo ${#string} #输出7
```

### 提取子字符串  

```shell
string="runoob is a great site"
echo ${string:1:4} #输出 unoo
```




## 传参

## 数组

## 运算符

## echo命令

## printf命令

## test命令

## 流程控制

## 函数

## 输入/输出重定向

## 文件包含

## over
