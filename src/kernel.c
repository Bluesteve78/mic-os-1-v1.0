/* src/kernel.c - tiny kernel that writes to VGA text buffer */

typedef unsigned long size_t;
static volatile unsigned short *vga = (unsigned short*)0xB8000;

void putc(char c, int pos){
    vga[pos] = (unsigned short)c | (0x0F << 8); /* white on black */
}

void print(const char *s){
    int pos = 0;
    while(*s){
        putc(*s++, pos++);
    }
}

void kernel_main(void){
    print("Hello from MIC!");
    for(;;) __asm__ __volatile__("hlt");
}

/* Provide stack_top symbol for boot.s via the linker by placing
   a small object with space reserved (linker script uses .bss). */
unsigned long _stack_reserved[512];
__attribute__((weak)) unsigned long *stack_top = &_stack_reserved[512];
