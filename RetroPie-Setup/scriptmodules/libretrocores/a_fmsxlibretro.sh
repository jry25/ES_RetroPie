rp_module_id="a_fmsxlibretro"
rp_module_desc="MSX LibretroCore FMSX (Additional)"
rp_module_menus="4+"

function sources_a_fmsxlibretro() {
    gitPullOrClone "$rootdir/emulatorcores/fmsx-libretro" git://github.com/libretro/fmsx-libretro.git
}

function build_a_fmsxlibretro() {
    pushd "$rootdir/emulatorcores/fmsx-libretro"
    
    [ -z "${NOCLEAN}" ] && make -f Makefile clean
    make -f Makefile platform="${FORMAT_COMPILER_TARGET}" ${COMPILER} 2>&1 | tee makefile.log
    [ ${PIPESTATUS[0]} -ne 0 ] && __ERRMSGS="Could not successfully compile MSX LibretroCore FMSX!"
    [ -f makefile.log ] && cp makefile.log $outputdir/_log.makefile.fmsxlibretro

    popd
}

function copy_a_fmsxlibretro() {
    [ -z "$so_filter" ] && so_filter="*libretro*.so"
    find $rootdir/emulatorcores/fmsx-libretro/ -name $so_filter | xargs cp -t $outputdir
}
