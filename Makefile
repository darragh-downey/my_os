CROSS_COMPILE=clang
LLD=ld.lld

# Common CFLAGS for both assembly and C files
COMMON_CFLAGS=-Wall -Wextra -Werror -O2 -target riscv64 -march=rv64ima -mabi=lp64

# Additional flags for C files
CFLAGS=$(COMMON_CFLAGS) -nostdlib -D_FORTIFY_SOURCE=2 -fstack-protector-strong

# Flags for linking
LDFLAGS=-T linker.ld

all: kernel.elf

boot/boot.o: boot/boot.s
	$(CROSS_COMPILE) $(COMMON_CFLAGS) -c -o $@ $<

kernel/kernel.o: kernel/kernel.c
	$(CROSS_COMPILE) $(CFLAGS) -c -o $@ $<

kernel.elf: boot/boot.o kernel/kernel.o
	$(LLD) $(LDFLAGS) -o $@ $^

analyze: kernel/kernel.c
	clang-tidy kernel/kernel.c -- -Wall -Wextra -Werror

clean:
	rm -f boot/*.o kernel/*.o kernel.elf
