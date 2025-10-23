# Makefile for MIC
CC = gcc
LD = ld
OBJCOPY = x86_64-elf-objcopy
CFLAGS = -ffreestanding -O2 -mno-red-zone -Wall -Wextra -nostdlib -fno-builtin
LDFLAGS = -T linker.ld -nostdlib

BUILD_DIR = build
ISO = mic.iso

.PHONY: all iso run clean

all: $(BUILD_DIR)/kernel.elf

$(BUILD_DIR)/kernel.elf: src/boot.s src/kernel.c linker.ld
	mkdir -p $(BUILD_DIR)
	$(CC) $(CFLAGS) -c src/kernel.c -o $(BUILD_DIR)/kernel.o
	$(CC) $(CFLAGS) -c src/boot.s -o $(BUILD_DIR)/boot.o
	$(LD) $(LDFLAGS) $(BUILD_DIR)/boot.o $(BUILD_DIR)/kernel.o -o $(BUILD_DIR)/kernel.elf

iso: all
	mkdir -p iso/boot
	cp $(BUILD_DIR)/kernel.elf iso/boot/kernel.elf
	grub-mkrescue -o $(ISO) iso

run: iso
	qemu-system-x86_64 -cdrom $(ISO) -m 512M -nographic -serial mon:stdio

clean:
	rm -rf $(BUILD_DIR) iso $(ISO)
