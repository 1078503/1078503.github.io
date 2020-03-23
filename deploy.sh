hugo
git add -A
git commit -m "重大主题更换操作"
git push origin master

git pull origin master

git config  credential.helper store
git config --global credential.helper store
####################################  https://zhuanlan.zhihu.com/p/46973701
export http_proxy=http://127.0.0.1:1081
export https_proxy=http://127.0.0.1:1081

git config --global http.https://github.com.proxy http://127.0.0.1:1081
git config --global https.https://github.com.proxy http://127.0.0.1:1081

export ALL_PROXY=socks5://127.0.0.1:1080

unset http_proxy
unset https_proxy
#####################################
