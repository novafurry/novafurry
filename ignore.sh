#!/usr/bin/env bash
/usr/bin/qemu-system-x86_64 \
    -name macos-big-sur,process=macos-big-sur \
    -machine q35,hpet=off,smm=off,vmport=off,accel=kvm \
    -global kvm-pit.lost_tick_policy=discard \
    -global ICH9-LPC.disable_s3=1 \
    -device isa-applesmc,osk=ourhardworkbythesewordsguardedpleasedontsteal\(c\)AppleComputerInc \
    -global nec-usb-xhci.msi=off \
    -cpu host,-pdpe1gb,+hypervisor \
    -smp cores=2,threads=2,sockets=1 \
    -m 10G \
    -device virtio-balloon \
    -rtc base=localtime,clock=host,driftfix=slew \
    -pidfile macos-big-sur/macos-big-sur.pid \
    -vga none \
    -device VGA,xres=1920,yres=1080,vgamem_mb=2000 \
    -device VGA,xres=1920,yres=1080,vgamem_mb=2000 \
    -display sdl,gl=on \
    -device virtio-rng-pci,rng=rng0 \
    -object rng-random,id=rng0,filename=/dev/urandom \
    -device nec-usb-xhci,id=spicepass \
    -chardev spicevmc,id=usbredirchardev1,name=usbredir \
    -device usb-redir,chardev=usbredirchardev1,id=usbredirdev1 \
    -chardev spicevmc,id=usbredirchardev2,name=usbredir \
    -device usb-redir,chardev=usbredirchardev2,id=usbredirdev2 \
    -chardev spicevmc,id=usbredirchardev3,name=usbredir \
    -device usb-redir,chardev=usbredirchardev3,id=usbredirdev3 \
    -device pci-ohci,id=smartpass \
    -device usb-ccid \
    -chardev spicevmc,id=ccid,name=smartcard \
    -device ccid-card-passthru,chardev=ccid \
    -device qemu-xhci,id=input \
    -device usb-kbd,bus=input.0 \
    -k en-us \
     -device usb-mouse \
    -device intel-hda \
    -device virtio-net,netdev=nic \
    -netdev user,hostname=macos-big-sur,hostfwd=tcp::22220-:22,id=nic \
    -global driver=cfi.pflash01,property=secure,value=on \
    -drive if=pflash,format=raw,unit=0,file=macos-big-sur/OVMF_CODE.fd,readonly=on \
    -drive if=pflash,format=raw,unit=1,file=macos-big-sur/OVMF_VARS-1920x1080.fd \
    -device ahci,id=ahci \
    -device ide-hd,bus=ahci.0,drive=BootLoader,bootindex=0 \
    -drive id=BootLoader,if=none,format=qcow2,file=macos-big-sur/OpenCore.qcow2 \
    -device ide-hd,bus=ahci.1,drive=RecoveryImage \
    -drive id=RecoveryImage,if=none,format=raw,file=macos-big-sur/RecoveryImage.img \
    -device virtio-blk-pci,drive=SystemDisk \
    -drive id=SystemDisk,if=none,format=qcow2,file=macos-big-sur/disk.qcow2 \
    -fsdev local,id=fsdev0,path=/home/n/,security_model=mapped-xattr \
    -audio sdl \
    -device virtio-9p-pci,fsdev=fsdev0,mount_tag=Public-n 
#    -serial unix:macos-big-sur/macos-big-sur-serial.socket,server,nowait


#     -monitor unix:macos-big-sur/macos-big-sur-monitor.socket,server,nowait \
