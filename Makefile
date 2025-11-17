all: bin/niyos.bin

bin/niyos.bin: bin/bootloader.bin bin/bootinstaller.bin bin/installboot.bin bin/niyosfs.bin
	dd if=bin/bootloader.bin of=bin/niyos.bin bs=512 count=1
	dd if=bin/bootinstaller.bin of=bin/niyos.bin bs=512 seek=1
	dd if=bin/installboot.bin of=bin/niyos.bin bs=512 seek=2
	dd if=bin/niyosfs.bin of=bin/niyos.bin bs=512 seek=3

bin/bootloader.bin: src/bootloader.asm
	fasm src/bootloader.asm bin/bootloader.bin

bin/bootinstaller.bin: src/bootinstaller.asm
	fasm src/bootinstaller.asm bin/bootinstaller.bin

bin/installboot.bin: src/installboot.asm
	fasm src/installboot.asm bin/installboot.bin

bin/niyosfs.bin: src/niyosfs.asm
	fasm src/niyosfs.asm bin/niyosfs.bin

load: hdd.img bin/niyos.bin
	qemu-system-x86_64 -drive format=raw,file=bin/niyos.bin,if=ide,index=0 -drive format=raw,file=hdd.img,if=ide,index=1

loadhdd: hdd.img
	qemu-system-x86_64 -drive format=raw,file=hdd.img,if=ide,index=0

createhdd:
	qemu-img create -f raw hdd.img 1M

clean:
	rm -rf bin/*.bin bin/niyos.bin