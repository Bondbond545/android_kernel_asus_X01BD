#!/usr/bin/env bash
# Copyright (C) 2019 ZyCromerZ


export CROSS_COMPILE=~/aarch64-linux-android-4.9/bin/aarch64-linux-android-
export ARCH=arm64
export SUBARCH=arm64 
export KBUILD_BUILD_USER="noob"
export KBUILD_BUILD_HOST="Laptop"
KERNEL_DIR=$PWD
build(){
    make O=out m2pro_defconfig
    make O=out -j$(nproc --all)
}
clean(){
    make O=out clean 
    make O=out mrproper   
}
makeFlashable(){
    KERN_IMG=$KERNEL_DIR/out/arch/arm64/boot/Image.gz-dtb
    ZIP_DIR=$KERNEL_DIR/AnyKernel3
    ZIP_KERNEL_VERSION="4.4.$(cat "$KERNEL_DIR/Makefile" | grep "SUBLEVEL =" | sed 's/SUBLEVEL = *//g')"
    KERNEL_NAME=$(cat "./arch/arm64/configs/X01BD_defconfig" | grep "CONFIG_LOCALVERSION=" | sed 's/CONFIG_LOCALVERSION="-*//g' | sed 's/"*//g' )
    ZIP_NAME="[$(date +"%m%d" )]$KERNEL_NAME-$(echo $ZIP_KERNEL_VERSION).zip"
	cp $KERN_IMG $ZIP_DIR
    cd $ZIP_DIR
    KernelOutput=~/kernel_output/$ZIP_NAME
    zip -r $KernelOutput ./ -x /.git/*
    sleep 1
    echo "done,your file now at $KernelOutput"
    cd $KERNEL_DIR
}
Choice(){
    clear
    echo "1 > clean "
    echo "2 > build "
    echo "3 > makezip "
    echo "4 > clean > build > makezip"
    echo "5 > build > makezip"
    echo "press anykey to quit . . ."
    read GetInput

    if [ "$GetInput" == "1" ];then
        clean
        echo "done . . "
        echo -n "press any key to continue"
        read -n 1
        Choice
    elif [ "$GetInput" == "2" ];then
        build
        echo "done . . "
        echo -n "press any key to continue"
        read -n 1
        Choice
    elif [ "$GetInput" == "3" ];then
        makeFlashable
        echo "done . . "
        echo -n "press any key to continue"
        read -n 1
        Choice
    elif [ "$GetInput" == "4" ];then
        clean
        build
        makeFlashable
        echo "done . . "
        echo -n "press any key to continue"
        read -n 1
        Choice
    elif [ "$GetInput" == "5" ];then
        build
        makeFlashable
        echo "done . . "
        echo -n "press any key to continue"
        read -n 1
        Choice
    else
        echo "bye . . ."
    fi;
}
Choice