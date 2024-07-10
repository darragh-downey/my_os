OUTPUT_ARCH(riscv)

ENTRY(_start)

SECTIONS {
    . = 0x80200000;

    .text :
    {
        *(.text.boot)
        *(.text*)
    }

    .rodata :
    {
        *(.rodata*)
    }

    .data :
    {
        *(.data*)
    }

    .bss :
    {
        *(COMMON)
        *(.bss*)
    }

    .trap_handler :
    {
        KEEP(*(.trap_handler))
    }
}
