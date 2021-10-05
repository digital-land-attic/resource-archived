cd docs
find . -name index.html -print |
while read path
do
t=$(dirname $path| sed -e 's/\.\///')
cat > $path <<-!
<meta http-equiv="refresh" content="0; url=https://www.digital-land.info/resource/$t/">
!
done
