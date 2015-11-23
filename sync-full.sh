#!/bin/sh
if [ ! -t 0 ]; then
x-terminal-emulator -e "$0"
exit 0
fi
basedir=`dirname "$(readlink -f "${0}")"`
cd ${basedir}
rm -rf .git
git init
git add .
read MESSAGE
git commit -m "$MESSAGE"
git remote add origin https://github.com/sixsixfive/Glare.git
git push -u --force origin master
echo "done"
sleep 5
exit