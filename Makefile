all: bin/niyos.bin

bin/niyos.bin: bin/bootloader.bin bin/installer.bin bin/hddboot.bin bin/console.bin bin/niyfs.bin bin/niyerror.bin bin/niyexec.bin
	dd if=bin/bootloader.bin of=bin/niyos.bin bs=512 count=1
	dd if=bin/installer.bin of=bin/niyos.bin bs=512 seek=1
	dd if=bin/hddboot.bin of=bin/niyos.bin bs=512 seek=3
	dd if=bin/console.bin of=bin/niyos.bin bs=512 seek=4
	dd if=bin/niyfs.bin of=bin/niyos.bin bs=512 seek=6
	dd if=bin/niyerror.bin of=bin/niyos.bin bs=512 seek=9
	dd if=bin/niyexec.bin of=bin/niyos.bin bs=512 seek=10

bin/bootloader.bin: src/bootloader.asm
	fasm src/bootloader.asm bin/bootloader.bin

bin/installer.bin: src/installer.asm
	fasm src/installer.asm bin/installer.bin

bin/hddboot.bin: src/hddboot.asm
	fasm src/hddboot.asm bin/hddboot.bin

bin/console.bin: src/console.asm
	fasm src/console.asm bin/console.bin

bin/niyfs.bin: src/niyfs.asm
	fasm src/niyfs.asm bin/niyfs.bin

bin/niyerror.bin: src/niyerror.asm
	fasm src/niyerror.asm bin/niyerror.bin

bin/niyexec.bin: src/niyexec.asm
	fasm src/niyexec.asm bin/niyexec.bin

load: hdd.img bin/niyos.bin
	qemu-system-x86_64 -drive format=raw,file=bin/niyos.bin,if=ide,index=0 -drive format=raw,file=hdd.img,if=ide,index=1

loadhdd: hdd.img
	qemu-system-x86_64 -drive format=raw,file=hdd.img,if=ide,index=0

createhdd:
	qemu-img create -f raw hdd.img 10M
	
clean:
	rm -rf bin/*.bin bin/niyos.bin