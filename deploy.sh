hugo
git add -A
git commit -m "update"
git push -u origin master

git pull origin master

git remote add origin git@github.com:1078503/blog.git

git config  credential.helper store
git config --global credential.helper store
####################################  https://zhuanlan.zhihu.com/p/46973701/
export http_proxy=http://127.0.0.1:1081
export https_proxy=http://127.0.0.1:1081

git config --global http.https://github.com.proxy http://127.0.0.1:1081
git config --global https.https://github.com.proxy http://127.0.0.1:1081

export ALL_PROXY=socks5://127.0.0.1:1080

unset http_proxy
unset https_proxy

set http_proxy=http://127.0.0.1:10809
set https_proxy=http://127.0.0.1:10809

git config --global user.name "1078503"
git config --global user.email "1078503@gmail.com"

ssh-keygen -t rsa -C "1078503@gmail.com"

ssh -T git@github.com

git rm -r --cached "themes"
######################################
dtrx wenjianming.tar.gz
