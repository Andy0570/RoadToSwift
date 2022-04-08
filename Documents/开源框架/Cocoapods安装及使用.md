* GitHub: [CocoaPods](https://github.com/CocoaPods/CocoaPods)
* star: 12.4k

它是用 Ruby 写的，并划分为多个 gem 包。它依赖于 Ruby 环境。

## 安装步骤

### 1. 更新系统 Ruby 环境

```bash
# 这一步骤需要科学上网
$ sudo gem update --system

# 查看已安装的 Ruby 版本（最新版本：3.0.6，截止20200430）
$ gem -v
```

### 2. 安装 CocoPods 前先替换镜像源

默认的镜像资源服务器被天朝给墙了。所以需要先更换源地址，然后再安装。

* 移除原先的 Ruby 源：
```bash
$ gem sources --remove https://rubygems.org/
```

* 指定为 [Ruby China](https://gems.ruby-china.com/) 的镜像源：
```bash
$ gem sources --add https://gems.ruby-china.com/
```
🔗 相关链接：[Ruby China 的 RubyGems 镜像上线](https://ruby-china.org/topics/29250)

* 验证新源是否替换成功：
```bash
$ gem sources -l
*** CURRENT SOURCES ***

https://gems.ruby-china.com/
```

### 3. 安装 CocoaPods
使用 ruby 的 gem 命令下载并安装 CocoaPods。

1. ~~`$sudo gem install cocoapods`~~
备注：以上命令在 Mac OS 系统升级到 OS X EL Capitan 版本后需要改为 : `$ sudo gem install -n /usr/local/bin cocoapods`

2. `$ pod setup`

## 使用 CocoaPods 的镜像索引

所有项目的 Podspec 文件都托管在 <https://github.com/CocoaPods/Specs> 中。第一次执行 `pod setup` 时，CocoaPods 会将这些 Podspec 索引文件更新到本地的 `~/.cocoapods/ `目录下，该索引文件较大且更新非常缓慢。

将 CocoaPods 设置成 gitcafe 或者  occhina 镜像，执行索引更新时会快很多。

```bash
pod repo remove master
pod repo add master https://gitcafe.com/akuandev/Specs.git
pod repo update
```

也可以将以上代码中的 `https://gitcafe.com/akuandev/Specs.git`  替换成 `http://git.oschina.net/akuandev/Specs.git` 即可使用 occhina 上的镜像。

添加新源时报错：
```bash
➜  ~ pod repo add master https://git.coding.net/CocoaPods/Specs.git
[!] To setup the master specs repo, please run `pod setup`.
➜  ~ git clone https://git.coding.net/CocoaPods/Specs.git ~/.cocoapods/repos/master
```
—— 参考自：https://lamjack.github.io/2016/cocoapods-install-and-use/



## 搜索相关框架

打开终端，输入以下命令：

```bash
pod search 框架名

# 如，搜索网络框架 AFNetworking
pod search AFNetworking
```

链接：[mac终端命令](http://blog.csdn.net/zhaoweixing1989/article/details/13997917)

## 移除 trunk 源

如果执行 `pod` 相关命令时，显示 CDN 无法连接、连接超时之类的情况，可以移除 trunk 源，然后在   `Podfile` 文件中第一行指明依赖库的来源地址，不使用默认 CDN。

```bash
$ pod repo remove trunk
```

## 项目中使用：

1. 创建 **Podfile** 文件。

    新建 Xcode 项目，**在终端里 cd 到项目的主文件夹(就是包含 项目.xcodeproj 的文件)。**执行命令：

    ```bash
    # 1. 创建 Podfile 文件
    $ pod init
    
    # 2. 编辑 Podfile 文件
    $ vim Podfile
    ```

2. 编辑 **Podfile** 文件。

    执行 `vim Podfile` 命令后，会打开上一步骤创建的 `Podfile` 文件，你需要通过 `vim` 编辑此文件，默认进入**命令模式**。

    编辑 **Podfile** 文件时，至少需要会使用的几个 shell 命令：

    | 键盘命令      | 描述                                                         |
    | ------------- | ------------------------------------------------------------ |
    | `i`           | input，**输入模式**                                          |
    | `ESC`         | 从**输入模式**退出到**命令模式**                             |
    | `shift` + `:` | 在**命令模式**下，输入该键盘组合命令，就会进入**末行模式**   |
    | `wq`          | 在**末行模式**下，输入 `wq` ，即 write and quit，保存并退出！ |
    
3. 保存文件后，安装第三方库。
    更新依赖库，执行  `pod update`（记得cd 到项目主文件下）。
   安装依赖库，执行 `pod install`。

4. 安装完成，此时项目文件中会多出 .xcworkspace 文件，以后就通过它来打开项目。



## Podfile 文件示例


```bash
# 指明依赖库的来源地址，不使用默认 CDN
source  '[https://github.com/CocoaPods/Specs.git](https://github.com/CocoaPods/Specs.git)'

# Uncomment this line to define a global platform for your project
platform :ios, '8.0'
# 屏蔽所有第三方框架警告
inhibit_all_warnings!    

target 'ProjectName' do

  # Uncomment this line if you're using Swift or would like to use dynamic frameworks
  # use_frameworks!

  # Pods for ProjectName

  # 网络库
  pod 'AFNetworking'
  pod 'YTKNetwork'
  pod 'SDWebImage'
  pod 'Reachability', '~> 3.2'

  # 服务类
  pod 'QQ_XGPush'
  pod 'Bugly'

  # UI
  pod 'Masonry'
  pod 'MBProgressHUD'
  pod 'MJRefresh'
  pod 'EAIntroView'
  pod 'SDCycleScrollView'
  pod 'DZNEmptyDataSet'
  pod 'XLForm'
  pod 'SHSPhoneComponent'
  pod 'BEMCheckBox'
  pod 'SCLAlertView-Objective-C'

  # 工具组件类
  pod 'ChameleonFramework'
  pod 'FDFullscreenPopGesture'
  pod 'IQKeyboardManager'
  pod 'YYKit'
  pod 'UIAlertController+Blocks'
  pod 'LBXScan/LBXNative'
  pod 'LBXScan/UI'
  pod 'UITableView+FDTemplateLayoutCell'

end

target 'ProjectNameTests' do
  inherit! :search_paths
end

"Podfile" 52L, 999C
```


More: 

* [Podfile 文件用法详解](https://www.jianshu.com/p/b8b889610b7e)
* [Podfile语法参考(译)](http://www.jianshu.com/p/8af475c4f717)

Podfile 版本号含义：
```bash
= version 要求版本大于或者等于version，当有新版本时，都会更新至最新版本
< version 要求版本小于version，当超过version版本后，都不会再更新
<= version 要求版本小于或者等于version，当超过version版本后，都不会再更新
~> version 比如 version=1.1.0 时，范围在[1.1.0, 2.0.0)。注意2.0.0是开区间，也就是不包括2.0.0。
```

## 常用命令 Cheatsheet

以下是我整理的一份 Cocoapods 常用命令。

```bash
###### 安装 Cocoapods ######

# 更新 gem 版本
$ sudo gem update --system

# 查看已安装的 Ruby 版本
$ gem -v

# 替换 Ruby 源
$ gem sources --remove [https://rubygems.org/](https://rubygems.org/)
$ gem sources -add [https://gems.ruby-china.com/](https://gems.ruby-china.com/)

# 查看验证镜像源
$ gem sources -l

# 卸载 Cocoapods
$ sudo gem uninstall cocoapods

# 重新安装 Cocoapods 到指定目录
$ sudo gem install cocoapods -n /usr/local/bin

# 查看当前 Cocoapods 版本
$ pod --version

# 更新本地的 Cocoapods 列表
$ pod repo update

# 移除 trunk 源
$ pod repo remove trunk

###### 项目中使用 ######

# 搜索框架
$ pod search 框架名

# 终端导航到项目目录下
$ cd [Project]

# 创建 Podfile 文件
$ pod init

# 编辑 Podfile 文件
$ vim Podfile

# 安装
$ pod install

# 更新所有依赖的开源库
$ pod update
$ pod install --no-repo-update
$ pod update --no-repo-update

# 查看依赖库版本信息
$ pod install --verbose --no-repo-update
```


## 常见错误

### 错误 1

```bash
Error fetching http://ruby.taobao.org/:
bad response Not Found 404 (http://ruby.taobao.org/specs.4.8.gz)
```

  解决方案：把安装流程中 `gem sources -a http://ruby.taobao.org/`  改为 `gem sources -a https://ruby.taobao.org/`



### 错误 2

```bash
ERROR:  While executing gem ... (Errno::EPERM)
Operation not permitted - /usr/bin/pod
```

解决方案：苹果系统升级OS X EL Capitan后会出现的插件错误，将安装流程安装CocoaPods 的 (1) `sudo gem install cocoapods` ——>改为 `sudo gem install -n /usr/local/bin cocoapods` 即可。



### 错误 3

`````bash
ERROR:The dependency is not used in any concrete target
The dependency AFNetworking is not used in any concrete target
`````

解决方案：

Step 1：安装cocoapods的预览版本

```bash
sudo gem install cocoapods --pre
```

Step 2：修改Podfile格式

 ```bash
 platform :ios, '8.0'

 target 'MyApp' do

 pod 'AFNetworking', '~> 2.6'
 pod 'ORStackView', '~> 3.0'

 end
 ```
里面的 MyApp 记得替换为自己项目里的 target。

Step 3：更新pod

```bash
pod update
pod install
```



### 错误 4

```bash
error: RPC failed; curl 56 LibreSSL SSL_read: SSL_ERROR_SYSCALL, errno 54
```

![](http://upload-images.jianshu.io/upload_images/2648731-685f15a8cea08000.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/600)

SSL证书错误，解决方案参考：https://gems.ruby-china.org/

```bash
vim ~/.gemrc  # 配置该文件，关闭SSL验证
```

文件如下：

```bash
---
:backtrace: false
:bulk_threshold: 1000
:sources:
- https://gems.ruby-china.org/
:ssl_verify_mode: 0   # 新增此处代码
:update_sources: true
:verbose: true
```



### 错误 5

```bash
RPC failed; curl 18 transfer closed with outstanding read data remaining
```

解决方案，增加缓冲区内存：

```bash
git config http.postBuffer 524288000
```



### 错误 6

Xcode 9.3 下运行 `pod init` 报错：


### Error

```bash
RuntimeError - [Xcodeproj] Unknown object version.
/usr/local/lib/ruby/gems/2.4.0/gems/xcodeproj-1.5.2/lib/xcodeproj/project.rb:217:in `initialize_from_file'
/usr/local/lib/ruby/gems/2.4.0/gems/xcodeproj-1.5.2/lib/xcodeproj/project.rb:102:in `open'
/usr/local/lib/ruby/gems/2.4.0/gems/cocoapods-1.3.1/lib/cocoapods/command/init.rb:41:in `validate!'
/usr/local/lib/ruby/gems/2.4.0/gems/claide-1.0.2/lib/claide/command.rb:333:in `run'
/usr/local/lib/ruby/gems/2.4.0/gems/cocoapods-1.3.1/lib/cocoapods/command.rb:52:in `run'
/usr/local/lib/ruby/gems/2.4.0/gems/cocoapods-1.3.1/bin/pod:55:in `<top (required)>'
/usr/local/bin/pod:23:in `load'
/usr/local/bin/pod:23:in `<main>'
```
解决方法：安装Cocoapods预览版本:
```bash
sudo gem install cocoapods --pre
```
参考：[RuntimeError - [Xcodeproj] Unknown object version. ](https://github.com/CocoaPods/CocoaPods/issues/7458)



### 错误 7

`pod update` 报错，(Gem::GemNotFoundException)：

```bash
$ pod update
Traceback (most recent call last):
	2: from /usr/local/bin/pod:23:in `<main>'
	1: from /usr/local/Cellar/ruby/2.6.0_1/lib/ruby/2.6.0/rubygems.rb:302:in `activate_bin_path'
/usr/local/Cellar/ruby/2.6.0_1/lib/ruby/2.6.0/rubygems.rb:283:in `find_spec_for_exe': can't find gem cocoapods (>= 0.a) with executable pod (Gem::GemNotFoundException)
```

解决方案：
```bash
# 更新 gem 版本
sudo gem update --system

# 卸载 cocoapods
gem uninstall cocoapods

# 重新安装 cocoapods 到指定目录
sudo gem install cocoapods -n /usr/local/bin
```

默认情况下，安装 cocoapods 时（`sudo gem install cocoapods`）会被安装到 `/usr/bin` 目录下，但是苹果为了系统安全，该目录禁止任何写入，root 用户也不能。



## 参考

* [用CocoaPods做iOS程序的依赖管理 @唐巧](http://blog.devtang.com/2014/05/25/use-cocoapod-to-manage-ios-lib-dependency/) （阅读难度：★★）
* [iOS 最新版 CocoaPods 的安装流程](http://www.cnblogs.com/zxs-19920314/p/4985476.html) （阅读难度：★）
* [CocoaPods 公有库](https://www.jianshu.com/p/8111873cfaa9)
* [Cocoapods 入门 @不会开机的男孩](http://studentdeng.github.io/blog/2013/09/13/cocoapods-tutorial/)
* [看一遍就会的CocoaPods的安装和使用教程](http://www.jianshu.com/p/1711e131987d)，第三方库依赖管理工具，管理第三方库。
* [CocoaPods安装和使用教程](http://code4app.com/article/cocoapods-install-usage)
* [iOS 静态库，动态库与 Framework](https://skyline75489.github.io/post/2015-8-14_ios_static_dynamic_framework_learning.html)
* http://www.jianshu.com/p/8af475c4f717
* http://ios.jobbole.com/90957/

