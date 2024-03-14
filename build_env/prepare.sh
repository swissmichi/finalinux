echo "Dist Root: ${DIST_ROOT:?}"
echo "LFS: ${LFS:?}"

mkdir -p $LFS/sources

for f in $(cat $DIST_ROOT/build_env/build_env_list)
do
    bn=$(basename $f)

    if ! test -f $LFS/sources/$bn ; then
        wget $f -O $LFS/sources/$bn
    fi
done;

mkdir -pv $LFS/{bin,etc,lib,sbin,usr,var}
case $(uname -m) in
    x86_64) mkdir -pv $LFS/lib64 ;;
esac