/* src/boot.s - small multiboot header + entry */
.section .multiboot
.align 4
.long 0x1BADB002        /* multiboot magic */
.long 0x0               /* flags (let GRUB set them) */
.long -(0x1BADB002 + 0x0)

.section .text
.global start
.type start, @function
start:
    cli
    /* set a simple stack (linker provides stack_top) */
    lea stack_top(%rip), %rsp
    call kernel_main
halt:
    hlt
    jmp halt

/* reserve stack symbol (linker will place this) */
