hugo --baseUrl="https://dtz9.net/"
git init
git add --all
git commit -m "Initial blog repo"
git remote add origin https://github.com/1078503/blog.git
git push origin master

git pull origin master

publishDir = "docs"

git rm -r --cached "themes" 
git commit -m "更新themes"
git push -u origin master

git clone https://github.com/zzossig/hugo-theme-zzo.git

tar -zxvf ./hugo_0.60.0_Linux-64bit.tar.gz