rp_module_id="a_dolphinlibretro"
rp_module_desc="GAMECUBE/WII LibretroCore dolphin (Additional)"
rp_module_menus="2+"

function sources_a_dolphinlibretro() {
    gitPullOrClone "$rootdir/emulatorcores/libretro-dolphin" git://github.com/libretro/dolphin.git

    #pushd "$rootdir/emulatorcores/libretro-dolphin"
    #git submodule init && git submodule update
    #popd
}

function build_a_dolphinlibretro() {
    pushd "$rootdir/emulatorcores/libretro-dolphin/libretro"

    [ -z "${NOCLEAN}" ] && make -f Makefile clean
    if [[ ${FORMAT_COMPILER_TARGET} =~ "armv6" ]]; then
        make -f Makefile platform=rpi ${COMPILER} 2>&1 | tee makefile.log
    elif [[ ${FORMAT_COMPILER_TARGET} =~ "armv7" ]]; then
        make -f Makefile platform=rpi2 ${COMPILER} 2>&1 | tee makefile.log
    else
        make -f Makefile ${COMPILER} 2>&1 | tee makefile.log
    fi
    
    [ ${PIPESTATUS[0]} -ne 0 ] && __ERRMSGS="Could not successfully compile GAMECUBE/WII LibretroCore dolphin!"
    [ -f makefile.log ] && cp makefile.log $outputdir/_log.makefile.dolphinlibretro

    popd
}

function copy_a_dolphinlibretro() {
    [ -z "$so_filter" ] && so_filter="*libretro*.so"
    find $rootdir/emulatorcores/libretro-dolphin/libretro/ -name $so_filter | xargs cp -t $outputdir
}
