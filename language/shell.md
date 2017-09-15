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
