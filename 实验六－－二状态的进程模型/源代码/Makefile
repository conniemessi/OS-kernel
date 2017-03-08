LD_flags=-m elf_i386
C_flags=-m32 -mpreferred-stack-boundary=2 -ffreestanding

disk.img: boot.bin os.bin process1.com process2.com process3.com process4.com process5.com use1.com use2.com
	dd if=/dev/zero of=disk.img count=2880 bs=512
	dd if=boot.bin of=disk.img
	dd if=os.bin of=disk.img seek=1
#	dd if=use1.com of=disk.img seek=1
	dd if=process1.com of=disk.img bs=512 seek=36
	dd if=process2.com of=disk.img bs=512 seek=72 
	dd if=process3.com of=disk.img bs=512 seek=108
	dd if=process4.com of=disk.img bs=512 seek=144
	dd if=process5.com of=disk.img bs=512 seek=180
	dd if=use1.com of=disk.img bs=512 seek=252
	dd if=use2.com of=disk.img bs=512 seek=288


boot.bin: boot.asm 
	nasm -f bin boot.asm -o boot.bin

os.bin: os.o osc.o oslib.o  osclib.o process.o 
	ld $(LD_flags) -Ttext 0x7e00 --oformat binary $^ -o $@ -e main

os.o: kernel/os.asm
	nasm -f elf $^ -o $@

oslib.o: kernel/oslib.asm
	nasm -f elf $^ -o $@

osc.o: kernel/os.c
	gcc $(C_flags) -c $^ -o $@

process.o: kernel/process.c
	gcc $(C_flags) -c $^ -o $@

osclib.o: kernel/osclib.c
	gcc $(C_flags) -c $^ -o $@

process1.com:process1.asm 
	nasm -f bin $^ -o $@

process2.com:process2.asm 
	nasm -f bin $^ -o $@

process3.com:process3.asm 
	nasm -f bin $^ -o $@

process4.com:process4.asm 
	nasm -f bin $^ -o $@

process5.com:process5.asm 
	nasm -f bin $^ -o $@

use1.com:use1.asm 
	nasm -f bin $^ -o $@

use2.com:use2.asm 
	nasm -f bin $^ -o $@


clean:
	rm *.o *.bin *.com *.elf




