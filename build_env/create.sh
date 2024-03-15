set -e
echo "Dist Root: ${DIST_ROOT:?}"
echo "LFS: ${LFS:?}"


if test ! $(whoami) == "finabuild" ; then
    echo "Running this script with user other than finabuild! Stop that."
    echo "Please set up finabuild with the preparation script"
    exit -1
fi
echo "Creating build environment..."
cd $DIST_ROOT/build_env

bash -e build_scripts/binutils-pass-1.sh
bash -e build_scripts/gcc-pass-1.sh
bash -e build_scripts/linux-headers.sh
