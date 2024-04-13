all:
	nasm -felf32 -o calc.o calc.asm
	ld -m elf_i386 -o calc calc.o
