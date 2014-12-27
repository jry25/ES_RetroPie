rp_module_id="a_fbalibretro"
rp_module_desc="FBA LibretroCore (Additional)"
rp_module_menus="2+"

function depends_a_fbalibretro() {
    [ ${FORMAT_COMPILER_TARGET} = "armv6j-hardfloat" ] && rps_checkNeededPackages cpp-4.8 gcc-4.8 g++-4.8
}

function sources_a_fbalibretro() {
    gitPullOrClone "$rootdir/emulatorcores/fba-libretro" git://github.com/libretro/fba-libretro.git
}

function build_a_fbalibretro() {
    pushd "$rootdir/emulatorcores/fba-libretro"
 
    cd $rootdir/emulatorcores/fba-libretro/svn-current/trunk/

    [ -z "${NOCLEAN}" ] && make -f makefile.libretro clean || echo "Failed to clean!"
    if [ ${FORMAT_COMPILER_TARGET} = "armv6j-hardfloat" ]; then
        make -f makefile.libretro platform="${FORMAT_COMPILER_TARGET}" CC="gcc-4.8" CXX="g++-4.8" 2>&1 | tee makefile.log
    else
        make -f makefile.libretro platform="${FORMAT_COMPILER_TARGET}" ${COMPILER} 2>&1 | tee makefile.log
    fi
    [ ${PIPESTATUS[0]} -ne 0 ] && __ERRMSGS="Could not successfully compile FBA LibretroCore!"
    [ -f makefile.log ] && cp makefile.log $outputdir/_log.makefile.fbalibretro

    popd
}

function configure_a_fbalibretro() {
    mkdir -p $romdir/fba-libretro

    rps_retronet_prepareConfig
    setESSystem "Final Burn Alpha" "fba-libretro" "~/RetroPie/roms/fba-libretro" ".zip .ZIP .fba .FBA" "$rootdir/supplementary/runcommand/runcommand.sh 1 \"$rootdir/emulators/RetroArch/installdir/bin/retroarch -L `find $rootdir/emulatorcores/fba-libretro/ -name \"*libretro*.so\" | head -1` --config $rootdir/configs/all/retroarch.cfg --appendconfig $rootdir/configs/fba/retroarch.cfg $__tmpnetplaymode$__tmpnetplayhostip_cfile$__tmpnetplayport$__tmpnetplayframes %ROM%\"" "arcade" "fba"
}

function copy_a_fbalibretro() {
    [ -z "$so_filter" ] && so_filter="*libretro*.so"
    find $rootdir/emulatorcores/fba-libretro/ -name $so_filter | xargs cp -t $outputdir
}