[mitmproxy](https://mitmproxy.org/index.html) 是一款支持 HTTP/HTTPS 的中间人代理工具。

mitmproxy 包含如下套件：
* **mitmproxy** 提供了一个控制台接口用于动态拦截和编辑 HTTP 数据包。不同于 Fiddler2、burpsuite 等类似功能工具，mitmproxy 可在终端下运行。mitmproxy 使用 Python 语言开发，是辅助 web 开发&测试、移动端调试、渗透测试的工具。 
* **mitmdump** 是 mitmproxy 的命令行接口，功能类似于 HTTP 中的 tcpdump。
* **mitmweb** 是 mitmproxy 的 Web 页面接口。

## mitmproxy 的功能特性

* 拦截 HTTP 和 HTTPS 请求和响应。
* 保存 HTTP 会话并进行分析。
* 模拟客户端发起请求。
* 模拟服务端返回响应。
* 利用反向代理将流量转发给指定的服务器。
* 支持 Mac 和 Linux 上的透明代理。
* 利用 Python 对 HTTP 请求和响应进行实时处理。



## mitmproxy

在 Terminal 终端上，使用 [mitmproxy](https://mitmproxy.org/index.html) 工具实现 http 客户端请求数据的拦截和服务响应数据的拦截。

### 安装和运行 mitmproxy

这里给出两种安装 mitmproxy 的方式，一种是 Homebrew，另外一种是 pip。

#### 通过 Python 包管理工具安装 mitmproxy

1. 先要在Mac中安装 **pip**（Python包管理工具，主要是用于安装 PyPI 上的软件包，可以替代 easy_install 工具），打开 Terminal 终端，输入如下命令：   

	```bash
	$ sudo easy_install pip
	Searching for pip
	Reading https://pypi.python.org/simple/pip/
	...
	```

2. 安装**mitmproxy** 

	```bash
	$ sudo pip install mitmproxy --ignore-installed six
	```



#### 通过 HomeBrew 安装

在 Mac OS 系统中，可以通过 HomeBrew 安装 mitmproxy：

```bash
$ brew install mitmproxy
```

启动 mitmproxy：

```bash
$ mitmproxy
```

在终端下输入命令 `ifconfig en0` 可以查询 Mac 系统连接网络的当前 IP 地址：

![](https://upload-images.jianshu.io/upload_images/2648731-070fec3b9250f941.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

你也可以通过：键盘按住 **option** 键，然后鼠标左击 Mac 桌面菜单栏左上角的 Wi-Fi 图标查看本机 IP 地址。

iPhone 上设置 HTTP 代理（系统设置-无线局域网-点击当前网络 WI-FI 图标右侧的感叹号-配置 HTTP 代理），填写查询到的本机 IP 地址，端口号默认填写 8080：

![](https://upload-images.jianshu.io/upload_images/2648731-a0fa3b7729aa9927.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

第一次使用 mitmproxy 的时候，还需要在 iPhone 上安装 mitmproxy 的 CA 证书，iPhone 上的 HTTP 代理设置并保存完成后，手机浏览器打开 `mitm.it`，安装对应系统的 CA 证书即可。

### 查看 mitmproxy 流量

以 baidu.com 为例，手机浏览器打开该网页，即可查看到通过 mitmproxy 的流量。

在该请求列表界面：

![](https://upload-images.jianshu.io/upload_images/2648731-895b67dc2c0c0973.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

* 通过 j、k 或者上下方向键实现各个请求之间的逐项移动操作。
* 通过 G 移至最后一个请求。
* 通过 g 移至第一个请求。
* 在任意单个请求上，按回车键即可进入请求详情页面。再按 q 即可从请求详情页面返回到请求列表页面。

在请求详情界面：

![](https://upload-images.jianshu.io/upload_images/2648731-1839cf63120e9e41.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

* 通过 h、l 或者左右方向键实现 Request、Response、Detail 页面之间的切换。
* 也可以通过 Tab 键实现 Request、Response、Detail 页面之间的切换。



### 拦截 HTTP 请求

在请求列表界面中输入 `i`，进入 Intercept filter 拦截模式，可以通过正则表达式过滤的方式拦截指定的 HTTP 流量。

按 ESC 可以退出 Intercept filter 拦截模式。

比如说，你想要拦截所有通过 <http://google.com> 的流量，那么你就输入：

```
google.com
```

然后按回车。这时候所有通过 <http://google.com> 的流量都会被拦截，并用红色字体标出：

![](https://upload-images.jianshu.io/upload_images/2648731-4a771d4a8d688890.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

箭头索引到该请求上之后，键盘可以执行以下指令：

* `a` ，即 accept，放行流量；
* `r`，即 replay，重发 request 请求；
* `d`，即 delete，删除当前 field；

如果想要编辑该请求，可以回车键跳转到请求详情页面，按 `e`，即 edit，进入编辑模式，进入编辑模式后，具体的操作和 vi 操作相同。

如果你需要编辑请求的 query 字段，可以通过上下左右方向键切换要编辑的参数。还可以通过 `a` 增加查询参数。编辑完成后，按 esc  即可退出编辑模式，再按 `q` 返回到请求详情页面。

请求编辑完成后，退回到请求列表界面，按 `a` 即可放行流量。收到服务器的响应数据后，你也同样可以编辑响应参数，再执行放行操作。



## mitmdump

使用 mitmproxy 时，我们可以查看 HTTP 流量，也可以以交互式的方式实现拦截、编辑、放行流量。

但如果你只是想要修改请求或响应数据，而响应数据又是 JSON 数据类型或者 image 图片数据时，在 vim 编辑器中修改数据也不是非常方便。

而且当我想要进行移动端的 HTTP 抓包，并实时修改请求和响应数据时，即使 mitmproxy 使用非常熟练，一顿操作猛如虎，也很难保证在移动端 APP 请求超时之前在命令行中完成以上所有的操作。

我们还可以通过 mitmdump 工具，以脚本的方式自动执行相关的操作。

运行 mitmdump 的命令如下：

```bash
$ mitmdump -s script.py
```

其中，`-s` 参数表示当前目录下所对应的脚本文件，即 `script.py` 。




## 示例 python 脚本文件

### 改写请求头

该脚本向每个请求的请求头中都添加 `User-Agent` 字段：

```python
def request(flow):
    flow.request.headers['User-Agent'] = 'mitmproxy'
    print(flow.request.headers)
```

代码释义：

* 第一行：定义了一个 `request()` 方法，参数为 `flow`，它其实是一个 `HTTPFlow` 对象，通过 `request` 属性即可获取到当前请求对象。
* 第二行：将请求头中的 `User-Agent` 字段修改为 `mitmproxy`。 
* 第三行：通过 `print()` 方法在控制台打印输出请求的请求头。

### Request 的常用功能

```python
from mitmproxy import ctx

def request(flow):
    request = flow.request
    info = ctx.log.info
    info(request.url)
    info(str(request.headers))
    info(str(request.cookies))
    info(request.host)
    info(request.method)
    info(str(request.port))
    info(request.scheme)
```

直接赋值即可对任意属性作修改：

```python
def request(flow):
    url = 'https://httpbin.org/get'
    flow.request.url = url
```



### 日志输出

mitmdump 提供了专门的日志输出功能，可以设定不同级别以不同颜色输出日志结果：

```python
from mitmproxy import ctx

def request(flow):
    flow.request.headers['User-Agent'] = 'MitmProxy'
    ctx.log.info(str(flow.request.headers))
    ctx.log.warn(str(flow.request.headers))
    ctx.log.error(str(flow.request.headers))
```

代码释义：调用 `ctx` 模块，它有一个 log 功能，调用不同的输出方法就可以输出不同颜色的结果，以方便调试。例如：

* `info()` 方法输出白色文本。
* `warn()` 方法输出黄色文本。
* `error()` 方法输出红色文本。

### 修改响应的消息体

通过读取 json 文件的字符串并返给客户端：

```python
from mitmproxy import http, ctx
import json

class Modify:
  def response(self, flow):
    if flow.request.url.startswith("http://example.com"):
      with open('file.json','rb') as file:
        response = json.load(file)
      flow.response.set_text(json.dumps(response))
      ctx.log.info("modify json data.")

addons = [
  Modify()
]
```

把要返回的 JSON 数据文件放在和脚本文件相同的目录下。终端目录切换到该脚本文件的目录下，然后执行：

```bash
$ mitmdump -s script.py
```

运行应用，mitmdump 就会自动帮你替换响应数据。



## 附：mitmproxy 常用快捷键


以下 vim 命令可通过 `?` 获得

### This view:

|    A     |      接收所有被拦截的流      |
| :-------------  |:-------------|
| a      | 只接收该被拦截的流 |
| b      | 保存 request/response 体 |
| C  |  导出流到剪切板     |
| d  |	 删除流           |
| D  |  重复流          |
| e  |  切换事件日志      |
| E  |   导出流到文件     |
| f  |    过滤视图         |
| F  |     切换follow流列表|
| L  |       加载保存的流  |
| m  |     切换流标记     |
| M  |      切换标记的流视图|
| n  |      创建一个新的request  |
| r  |      重复request           |
| S  |      服务器重复request |
| U  |      取消标记所有被标记的流   |
| V  |       还原更改的请求     |
| w  |       保存流          |
| W  |       把流stream入文件    |
| X  |       杀死和删除流，即使它正被拦截 |
| z  |      清楚流或事件日志           |
| tab|       选项卡在事件日志和流列表之间切换  |
|enter|     查看流            |
| l   |     运行脚本            |

### Movement

|    j,k     |      下移，上移      |
| :-------------  |:-------------|
| h,l  |      左移，右移（在某些文本中）          |
| g,G  |       移至开头，结尾          |
| space  |       翻页 |
| page up/down |    翻页           |
| ctrl+b /ctrl+f|      翻页         |
| 方向键   |     上下左右移动           |

### Global keys

|    i    |      设置拦截模式     |
| :-------------  |:-------------|
| o  |      选项         |
| q |     后退，返回         |
| Q  |       退出而不需要确认提示 |
| R |   从文件中重复运行requests/responses           |

| 快捷键      | 描述              |
| ---------- | ---------------- |
| ~a         | 匹配 response：CSS，JavaScript，Flash，image    |
| ~b regex   | Body |
| ~bq regex  | request 请求体 |
| ~bs regex  | response 响应体 |
| ~c int     | HTTP response code |
| ~d regex   | 匹配特定的 Domain |
| ~dst regex | 匹配目标地址 |
| ~e         | 匹配错误 |
| ~h regex   | Header |
| ~hq regex  | Request header |
| ~hs regex  | Response header |
| ~http      | 匹配 http 流 |
| ~m regex   | Method |
| ~marked    | 匹配标记的流 |
| ~q         | 匹配 request |
| ~s         | 匹配 response |
| ~src regex | 匹配源地址 |
| ~t regex   | Content-type header |
| ~tcp       | 匹配 TCP 流 |
| ~tq regex  | Request Content-type header  |
| ~ts regex  | Response Content-type header |
| ~u regex   | URL |
| !          | 非 |
| &          | 与 |
| l          | 或 |
| (...)      | 集合 |


* 正则表达式是 **Python** 风格的。
* 正则表达式可以被指定为带引号的字符串。
* Header匹配(~h,~hq,~hs)是针对“name:value”形式的字符串。
* 没有运算符的表达式与URL的正则表达式匹配
* 默认的二进制运算符是 &


| 正则表达式示例 | 说明 |
|-------------| :----------------: |
| google.com | URL包含“google.com” |
| ~q ~b test  | Request请求体中包含“test” |
| !(~q & ~t "text/html") | 除了Request请求中带有 “text/html” 的内容类型 |
| ~c 404      | 拦截指定 HTTP 响应状态码 404 |
| ~m POST     | 拦截所有的 POST 请求 |




## 参考

* [和Charles同样强大的iOS免费抓包工具mitmproxy](https://zhuanlan.zhihu.com/p/23878149)（阅读难度：★★★）
* [使用mitmproxy进行移动端的HTTP抓包](http://hello1010.com/mitmproxy-android)（阅读难度：★★）
* [mitmproxy实践教程之调试 Android 上 HTTP流量](http://greenrobot.me/devpost/how-to-debug-android-http-get-started/)（阅读难度：★★）
* [App 爬虫神器 mitmproxy 和 mitmdump 的使用](https://juejin.im/post/5ac9ea6d518825364001b5b9)
* [mitmproxy 使用 (二)- 自定义脚本编写](https://blog.csdn.net/qianwenjun_19930314/article/details/88227335)
