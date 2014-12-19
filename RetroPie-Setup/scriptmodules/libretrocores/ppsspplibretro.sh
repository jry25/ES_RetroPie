rp_module_id="ppsspplibretro"
rp_module_desc="PSP LibretroCore PPSSPP"
rp_module_menus="2+"

function sources_ppsspplibretro() {
    gitPullOrClone "$rootdir/emulatorcores/libretro-ppsspp" git://github.com/libretro/libretro-ppsspp.git
    
    pushd "$rootdir/emulatorcores/ppsspp"
    git submodule init && git submodule update
    popd
}

function build_ppsspplibretro() {
    pushd "$rootdir/emulatorcores/ppsspp/libretro-ppsspp"

    [ -z "${NOCLEAN}" ] && make -f Makefile clean || echo "Failed to clean [code=$?] !"
    make -f Makefile platform="${FORMAT_COMPILER_TARGET}" ${COMPILER} || echo "Failed to build [code=$?] !"

    [ -z "$so_filter" ] && so_filter="*libretro*.so"
    if [[ -z `find $rootdir/emulatorcores/ppsspp/libretro-ppsspp/ -name "$so_filter"` ]]; then
        __ERRMSGS="$__ERRMSGS Could not successfully compile PPSSPP core."
    fi

    popd
}

function configure_ppsspplibretro() {
    mkdir -p $romdir/psp

    #rps_retronet_prepareConfig
    #setESSystem "Sega SATURN" "saturn" "~/RetroPie/roms/saturn" ".img .IMG .7z .7Z .pbp .PBP .bin .BIN .cue .CUE" "$rootdir/supplementary/runcommand/runcommand.sh 2 \"$rootdir/emulators/RetroArch/installdir/bin/retroarch -L `find $rootdir/emulatorcores/yabause/ -name \"*libretro*.so\" | head -1` --config $rootdir/configs/all/retroarch.cfg --appendconfig $rootdir/configs/saturn/retroarch.cfg $__tmpnetplaymode$__tmpnetplayhostip_cfile$__tmpnetplayport$__tmpnetplayframes %ROM%\"" "saturn" "saturn"
}

function copy_ppsspplibretro() {
    [ -z "$so_filter" ] && so_filter="*libretro*.so"
    find $rootdir/emulatorcores/ppsspp/libretro-ppsspp/ -name $so_filter | xargs cp -t $outputdir
}