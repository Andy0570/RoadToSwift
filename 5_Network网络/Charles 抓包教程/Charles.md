最近在学习[Charles](https://www.charlesproxy.com)网络封包分析工具的使用。

## 简介

**Charles** 是 Mac 上常用的截取网络封包的工具，在做 iOS 开发时，我们为了调试与服务器端的网络通讯协议，常常需要截取网络封包来分析。**Charles** 通过将自己设置成系统的网络访问代理服务器，使得所有的网络访问请求都通过它来完成，从而实现了网络封包的截取和分析。

### **Charles** 主要的功能

* 支持SSL代理。可以截取分析SSL的请求。
* 支持流量控制。可以模拟慢速网络以及等待时间（latency）较长的请求。
* 支持AJAX调试。可以自动将json或xml数据格式化，方便查看。
* 支持AMF调试。可以将Flash Remoting 或 Flex Remoting信息格式化，方便查看。
* 支持重发网络请求，方便后端调试。
* 支持修改网络请求参数。
* 支持网络请求的截获并动态修改。
* 检查HTML，CSS和RSS内容是否符合W3C标准。

参考的唐巧的这篇技术博客写的很详细，目前也是完全够用了。

iPhone设置代理后无法被**Charles**抓包的解决方法：Mac使用网线连接互联网（而不是WiFi）。
参考：[连接同一wifi配置Charles代理的问题](http://mrljdx.com/2016/06/16/连接同一wifi配置Charles代理的问题/?utm_source=tuicool&utm_medium=referral)。



## 参考

* [唐巧的技术博客：Charles 从入门到精通](http://blog.devtang.com/2015/11/13/charles-introduction/)（阅读难度：★★★）
* [~~杨社兵的技术博客:iOS开发抓包工具之Charles使用~~](http://www.yangshebing.com/2016/11/13/iOS开发抓包工具之Charles使用/)（阅读难度：★★★）