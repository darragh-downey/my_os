#include <stdint.h>

#define SIFIVE_TEST_BASE 0x100000
#define SIFIVE_TEST_FINISHER_FAIL 0x3333
#define SIFIVE_TEST_FINISHER_PASS 0x5555
#define UART_BASE 0x10000000
#define UART_RBR (UART_BASE + 0x00)  // Receiver Buffer Register
#define UART_THR (UART_BASE + 0x00)  // Transmitter Holding Register
#define UART_LSR (UART_BASE + 0x05)  // Line Status Register
#define UART_LSR_DR 0x01  // Data Ready
#define UART_LSR_THRE 0x20  // Transmitter Holding Register Empty

void putchar(char c) {
    volatile uint32_t* uart_thr = (volatile uint32_t*)UART_THR;
    volatile uint32_t* uart_lsr = (volatile uint32_t*)UART_LSR;
    while (!(*uart_lsr & UART_LSR_THRE));  // Wait for the transmitter holding register to be empty
    *uart_thr = c;
}

void print(const char* str) {
    while (*str) {
        putchar(*str++);
    }
}

__attribute__((noreturn)) void exit(int code) {
    volatile uint32_t* sifive_test = (volatile uint32_t*)SIFIVE_TEST_BASE;
    *sifive_test = (code == 0) ? SIFIVE_TEST_FINISHER_PASS : SIFIVE_TEST_FINISHER_FAIL;
    while (1) {}  // Ensure it does not return
}

void kmain() {
    // Add a startup message for debugging
    print("Entering kmain...\n");
    print("Hello, World!\n");

    // Simple loop to keep the kernel running
    while (1) {}
}
