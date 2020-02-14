hugo --theme=Mainroad --baseUrl="https://dtz9.net/"
cd public
git init
git add --all
git commit -m "Initial blog repo"
git remote add origin root@137.220.138.224:/root/blog.git
git remote set-url origin ssh://root@137.220.138.224:22/root/blog.git
git push origin master