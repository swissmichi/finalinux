echo "Dist Root: ${DIST_ROOT:?}"
echo "LFS: ${LFS:?}"


if test ! $(whoami) == "distbuild" ; then
    echo "Running this script with user other than finabuild! Stop that."
    echo "Please set up finabuild with the preparation script"
    exit -1
fi
echo "Creating build environment..."