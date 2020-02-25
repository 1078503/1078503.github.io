# 【分享】宝塔面板中通过GitHub同步博客仓库并通过webhook勾子拉取更新


今天博友[云中君](https://blog.shanbu.fun/)反馈，说他的博客又抽风了。

原因是他将静态博客托管在coding上面，可是今天coding挂了，导致他的博客无法访问。

这就很蛋疼了，写个博客本来就没几个人看还时不时失联，情何以堪。本来还有[GitHub](https://github.com/)等一些平台可以使用，但我觉得换个方式可能会更好也说不定？

他是通过[Gridea](https://gridea.dev/)客户端写博客并更新同步到仓库的，但Gridea目前并不支持直接同步到自己的私有服务器，据说未来可能会支持FTP方式同步到私有服务器对应的网站目录。但何必这么麻烦，Gridea能同步推送更新到GitHub仓库就很好办。目前大部分使用的服务器都是Linux系统居多，只要服务器支持git就可以使用webhook勾子拉取仓库更新，使服务器对应的网站根目录文件与GitHub仓库保持一致。博客通过私有服务器提供访问应该会相对稳定一些，毕竟我的某个VPS上面就只有我自己的博客使用，并没有其它网站和额外的服务占用这个VPS的资源。

那么，接下来就来完成这个工作，让他与我分享这个资源吧。

## 1.确保Gridea同步推送接口使用GitHub

这里我因为不使用该客户端所以不做说明，因为它的[官网](https://gridea.dev/)已经介绍的非常详细了。

## 2.宝塔面板新建网站并启用

我使用的服务器是 CentOS 7 系统，该系统默认自带有git所以可以直接使用。如果你的系统没有请自行安装。

CentOS 7 安装方法：`yum install git` ，其它系统请自行搜索和研究安装方式。

需要注意的地方：

- 域名需要解析到宝塔面板所在服务器的IP
- 启用https访问需要注册ssl证书并在面板对应的网站正确配置并启用

## 3.宝塔面板使用webhook插件

![](https://img.1078503.org/imgs/2019/11/c3fe9bfa4196d113.png)

如上图。

在宝塔面板的`软件商店`中搜索`webhook`安装并启用，在webhook插件的设置中添加一个调用条目：

![](https://img.1078503.org/imgs/2019/11/12fecd83901de133.png)

编辑该条目的shell命令并保存：

![](https://img.1078503.org/imgs/2019/11/fd3c9d3f1af3ef16.png)

命令内容参考：

```shell
#!/bin/bash
echo ""
#输出当前时间
date --date='0 days ago' "+%Y-%m-%d %H:%M:%S"
echo "Start"
#判断宝塔WebHook参数是否存在
if [ ! -n "$1" ];
then
          echo "param参数错误"
          echo "End"
          exit
fi
#git项目路径
gitPath="①/www/wwwroot/$1"
#git 网址
gitHttp="②https://github.com/1078503/blog.git"

echo "Web站点路径：$gitPath"

#判断项目路径是否存在
if [ -d "$gitPath" ]; then
        cd $gitPath
        #判断是否存在git目录
        if [ ! -d ".git" ]; then
                echo "在该目录下克隆 git"
                git clone $gitHttp gittemp
                mv gittemp/.git .
                rm -rf gittemp
        fi
        #拉取最新的项目文件
        git reset --hard origin/master
        git pull
        #设置目录权限
        chown -R www:www $gitPath
        echo "End"
        exit
else
        echo "该项目路径不存在"
        echo "End"
        exit
fi
```

`①/www/wwwroot/$1`：请将这部分内容修改为你的网站对应的目录，比如你的博客对应的目录是`/www/wwwroot/blog.shan.fun/`，请直接编辑修改成`/www/wwwroot/$1`即可。`$1`请保留以便后面GitHub中配置webhook调用时生效，请勿删除或更改。

`②https://github.com/1078503/blog.git` ：你的GitHub仓库对应的拉取地址。

![](https://img.1078503.org/imgs/2019/11/fdb87be7a455883c.png)

查看密钥：

![](https://img.1078503.org/imgs/2019/11/faf73f831b0ce66e.png)

## 4.GitHub配置webhook调用

打开GitHub对应仓库的`Settings`：

![](https://img.1078503.org/imgs/2019/11/ef2f6ddf8ec3c79a.png)

找到webhooks并Add webhook：

![](https://img.1078503.org/imgs/2019/11/de16c8f206705c3d.png)

如下图填写相关信息并保持：

![](https://img.1078503.org/imgs/2019/11/decba050e45dffa7.png)

`Payload URL`：` http://IP:端口/hook?access_key=密钥&param=目录名`

IP:端口：修改为宝塔面板对应的

密钥：为宝塔面板中webhook条目“查看密钥”获得的密钥，前文图中箭头所指。

目录名：为宝塔面板对应网站的根目录，比如是`/www/wwwroot/blog.shan.fun/`则直接写`blog.shan.fun`

示例：

`http://127.0.0.1:8888/hook?access_key=Hd4gl6BrPSvqH5vnSbSjgtwIY3Lf5KGomG1XEd5VHhJxrrFt&param=blog.shan.fun`

`Content type` 按图示选择

`Secret` 密钥同上

按图示检查设置好后保存。

## 5.Gridea中修改或新建文件（写文章也可以）同步推送后验证

[云中君](https://blog.shanbu.fun/)的验证方法是在博客页脚添加了我的链接😏，大爱：

![](https://img.1078503.org/imgs/2019/11/37ad8cf5521924b0.png)

画了个难看的箭头请无视😂。

通过上面的操作所有工作已经完成，接下来写博客就好。Gridea客户端正常同步后访问博客域名就能验证操作是否有效。注意由于涉及到服务器与GitHub仓库的通信，偶尔可能会有拉取不成功或缓慢的情况，这取决于你的服务器与GitHub之间的通信线路是否阻塞。不过，这种情况几乎可以忽略不计，除非你的服务器在国内。

最后，突然想到我自己使用的hugo静态博客其实也可以这样推送更新，原理是一样的，我只是绕过了GitHub仓库直接与服务器的git仓库通信而已。我之前没有把博客直接放在GitHub上面提供访问是因为听多了经常抽风的传闻，所以直接放在了VPS上。另外还有独立博客中“独立”二字的考虑。

参考：https://www.bt.cn/bbs/thread-5348-1-1.html
