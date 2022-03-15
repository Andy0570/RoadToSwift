# [perfops-cli](https://perfops.net/cli) - 一款IT运维工具

[GitHub：perfops-cli](https://github.com/ProspectOne/perfops-cli)

PerfOps CLI 是一款适合于运维人员使用的命令行工具，方便从多地点执行 ping、traceroute、mtr 等网络基准测试。
PerfOps 使用简单，你可以从位于全世界的数百个节点向目标地址发起网络测试。在不设置 API 密钥的条件下，它允许每小时进行 10 次测试，免费注册用户则可以在每小时内发起最多 200 次测试。

## Homebrew - MacOS 安装方法

使用 Homebrew 安装：
```shell
brew tap ProspectOne/perfops
brew install perfops
perfops --help
```

## 使用方法
```shell
$ perfops --help
perfops is a simple command line tool to interact with hunderds of servers around the world. Run benchmarks and debug your infrastructure without leaving your console.
perfops 是一个简单的命令行工具，可与世界各地的数百台服务器进行交互。 无需离开控制台即可运行基准测试并调试基础架构。

Usage:
  perfops [flags]
  perfops [command]

Examples:
perfops traceroute --from "New York" google.com

Available Commands:
  credits     Displays the remaing credits
  curl        Run a curl test on a domain name or IP address
  dnsperf     Find the time it takes to resolve a DNS record on a target
  help        Help about any command
  latency     Run a ICMP latency test on a domain name or IP address
  mtr         Run a MTR test on a domain name or IP address
  ping        Run a ping test on a domain name or IP address
  resolve     Resolve a DNS record on a domain name
  traceroute  Run a traceroute test on a domain name or IP address

Flags:
      --debug             Enables debug output
  -F, --from string       A continent, region (e.g eastern europe), country, US state or city
  -h, --help              help for perfops
  -J, --json              Print the result of a command in JSON format
  -K, --key string        The PerfOps API key (default is $PERFOPS_API_KEY)
  -N, --nodeid intSlice   A comma separated list of node IDs to run a test from
  -v, --version           Prints the version information of perfops

Use "perfops [command] --help" for more information about a command.
```

### ping - 测试网络连通性
1. 从亚洲（Asia）的随机一台服务器上 Ping baidu.com：
```shell
$ perfops ping --from Asia baidu.com
Node203, AS45102, Dubai, United Arab Emirates # Node203，AS45102，迪拜，阿拉伯联合酋长国
PING baidu.com (220.181.57.216) 56(84) bytes of data.
64 bytes from 220.181.57.216: icmp_seq=1 ttl=47 time=341 ms
64 bytes from 220.181.57.216: icmp_seq=2 ttl=47 time=342 ms
64 bytes from 220.181.57.216: icmp_seq=3 ttl=47 time=342 ms

--- baidu.com ping statistics ---
3 packets transmitted, 3 received, 0% packet loss, time 800ms
rtt min/avg/max/mdev = 341.865/342.230/342.800/0.789 ms
```

2. 从亚洲（Asia）的随机两台服务器上 Ping 某一个IP地址：
```shell
$ perfops ping --from Asia 52.14.183.223 --limit 2
Node297, AS199524, Seoul, South Korea # 韩国首尔的节点
PING 52.14.183.223 (52.14.183.223) 56(84) bytes of data.
64 bytes from 52.14.183.223: icmp_seq=1 ttl=39 time=193 ms
64 bytes from 52.14.183.223: icmp_seq=2 ttl=39 time=193 ms
64 bytes from 52.14.183.223: icmp_seq=3 ttl=39 time=193 ms

--- 52.14.183.223 ping statistics ---
3 packets transmitted, 3 received, 0% packet loss, time 802ms
rtt min/avg/max/mdev = 193.768/193.786/193.814/0.020 ms

Node112, AS14061, Bangalore, India # Node112，AS14061，班加罗尔，印度
PING 52.14.183.223 (52.14.183.223) 56(84) bytes of data.
64 bytes from 52.14.183.223: icmp_seq=1 ttl=41 time=233 ms
64 bytes from 52.14.183.223: icmp_seq=2 ttl=41 time=232 ms
64 bytes from 52.14.183.223: icmp_seq=3 ttl=41 time=232 ms

--- 52.14.183.223 ping statistics ---
3 packets transmitted, 3 received, 0% packet loss, time 801ms
rtt min/avg/max/mdev = 232.727/232.975/233.375/0.486 ms
```

### traceroute - 对域名或 IP 地址运行路由跟踪测试
从上海的某一台服务器测试 baidu.com 的路由跟踪：
```shell
$ perfops traceroute --from "Shanghai" baidu.com
Node276, AS37963, Shanghai, China
traceroute to baidu.com (123.125.115.110), 20 hops max, 60 byte packets
 2  11.222.252.181 (11.222.252.181)  5.770 ms  5.911 ms
 3  11.222.252.10 (11.222.252.10)  5.519 ms  52.961 ms
 4  11.220.159.58 (11.220.159.58)  1.760 ms  1.863 ms
 5  116.251.106.157 (116.251.106.157)  2.412 ms  2.402 ms
 6  140.205.50.225 (140.205.50.225)  2.185 ms  2.189 ms
 7  140.206.207.205 (140.206.207.205)  3.937 ms  4.036 ms
 8  140.206.207.29 (140.206.207.29)  4.209 ms  4.247 ms
 9  * *
10  139.226.227.33 (139.226.227.33)  9.367 ms  9.365 ms
11  219.158.6.165 (219.158.6.165)  30.609 ms  30.525 ms
12  * *
13  61.51.113.246 (61.51.113.246)  25.389 ms  25.578 ms
14  202.106.43.38 (202.106.43.38)  25.545 ms  25.531 ms
15  * *
16  * *
17  123.125.115.110 (123.125.115.110)  25.586 ms  25.594 ms
```

### latency - 对域名或 IP 地址运行 ICMP 延迟测试
分别在位于中国的随机10台服务器上测试 google.com 的ICMP延迟：
```shell
perfops latency --from China google.com --limit 10
Node208, AS37963, Hangzhou, China # 杭州，100%丢包😂
100% packet loss
Node329, AS37963, Hohhot, China # 呼和浩特，100%丢包😂
100% packet loss
Node207, AS37963, Beijing, China # 北京。。。😂
100% packet loss
Node276, AS37963, Shanghai, China # 上海。。。😂
100% packet loss
```
