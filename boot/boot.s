.section .text
.global _start

UART_BASE = 0x10000000

_start:
    # Set up the stack pointer
    la sp, stack_top

    # Print the debugging message "Booting..."
    la t0, msg        # Load address of the message into t0
    li t1, UART_BASE  # Load UART base address into t1
1:  lb t2, 0(t0)      # Load byte from address in t0 into t2
    beqz t2, 2f       # If t2 is zero (end of string), jump to label 2
    sb t2, 0(t1)      # Store byte in t2 to address in t1 (UART transmit)
    addi t0, t0, 1    # Increment address in t0 by 1
    j 1b              # Jump back to label 1 to process the next character
2:  # Call kernel main
    call kmain

    # Infinite loop to prevent returning
3:  j 3b              # Jump to label 3 (infinite loop)

.section .data
msg:
    .ascii "Booting...\n"

.section .bss
.space 4096
stack_top:
