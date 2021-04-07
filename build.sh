#!/bin/bash

mkdir -p build

targets=("windows-static-x86" "liblzo2.dll" "liblzo2.dll" "win-x86")
targets+=("windows-static-x64" "liblzo2.dll" "liblzo2.dll" "win-x64")
targets+=("linux-x64" "liblzo2.so.2.0.0" "liblzo2.so" "linux-x64")
targets+=("linux-armv6" "liblzo2.so.2.0.0" "liblzo2.so" "linux-arm")
targets+=("linux-arm64" "liblzo2.so.2.0.0" "liblzo2.so" "linux-arm64")

for ((i = 0; i < ${#targets[@]}; i += 4)); do
    target=${targets[$i]}
    src=${targets[$i+1]}
    dst=${targets[$i+2]}
    rid=${targets[$i+3]}
    
    docker run --rm dockcross/$target > build/dockcross-$target
    chmod +x build/dockcross-$target
    ./build/dockcross-$target cmake -B build/$target -S src/lzo/ -G Ninja -DENABLE_STATIC=0 -DENABLE_SHARED=1
    ./build/dockcross-$target ninja -C build/$target lzo_shared_lib
    mkdir -p runtimes/$rid/native
    cp build/$target/$src runtimes/$rid/native/$dst
done
