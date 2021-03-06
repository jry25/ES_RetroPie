rp_module_id="a_snes9xnextlibretro"
rp_module_desc="SNES LibretroCore Snes9xNext (Additional)"
rp_module_menus="2+"

function sources_a_snes9xnextlibretro() {
    gitPullOrClone "$rootdir/emulatorcores/snes9x-next" git://github.com/libretro/snes9x-next.git
}

function build_a_snes9xnextlibretro() {
    pushd "$rootdir/emulatorcores/snes9x-next"

    # OVERRIDE MAKEFILE IF NECESSARY
    [ -f "$rootdir/makefiles/${FORMAT_COMPILER_TARGET}/snes9x-next/Makefile.libretro" ] && cp "$rootdir/makefiles/${FORMAT_COMPILER_TARGET}/snes9x-next/Makefile.libretro" .

    [ -z "${NOCLEAN}" ] && make -f Makefile.libretro clean || echo "Failed to clean!"
    make -f Makefile.libretro platform="${FORMAT_COMPILER_TARGET}" ${COMPILER} 2>&1 | tee makefile.log
    [ ${PIPESTATUS[0]} -ne 0 ] && __ERRMSGS="Could not successfully compile SNES LibretroCore Snes9xNext!"
    [ -f makefile.log ] && cp makefile.log $outputdir/_log.makefile.snes9xnextlibretro

    popd
}

function copy_a_snes9xnextlibretro() {
    [ -z "$so_filter" ] && so_filter="*libretro*.so"
    find $rootdir/emulatorcores/snes9x-next/ -name $so_filter | xargs cp -t $outputdir
}