dir=`dirname $0`
git checkout master
cp -r $dir/tree/* .
cp -r $dir/tree/.[^.]* .
git am < $dir/patch
