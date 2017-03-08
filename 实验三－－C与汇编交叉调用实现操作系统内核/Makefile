LD_flags=-m elf_i386
C_flags=-m32 -mpreferred-stack-boundary=2 -ffreestanding

disk.img: boot.bin os.bin use1.com use2.com use3.com use4.com
	dd if=/dev/zero of=disk.img count=2880 bs=512
	dd if=boot.bin of=disk.img
	dd if=os.bin of=disk.img seek=1
	dd if=use1.com of=disk.img bs=512 seek=14
	dd if=use2.com of=disk.img bs=512 seek=15
	dd if=use3.com of=disk.img bs=512 seek=16
	dd if=use4.com of=disk.img bs=512 seek=17

boot.bin: boot.asm 
	nasm -f bin boot.asm -o boot.bin

os.bin: os.o osc.o oslib.o  osclib.o
	ld $(LD_flags) -Ttext 0x90100 --oformat binary $^ -o $@ -e main

os.o: os.asm
	nasm -f elf $^ -o $@

oslib.o: oslib.asm
	nasm -f elf $^ -o $@

osc.o: os.c
	gcc $(C_flags) -c $^ -o $@

osclib.o: osclib.c
	gcc $(C_flags) -c $^ -o $@

use1.com:use1.asm 
	nasm -f bin $^ -o $@

use2.com:use2.asm 
	nasm -f bin $^ -o $@

use3.com:use3.asm 
	nasm -f bin $^ -o $@

use4.com:use4.asm 
	nasm -f bin $^ -o $@

clean:
	rm *.o *.bin *.com




