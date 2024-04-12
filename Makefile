# compiler
SCC = gcc
CC = arm-none-eabi-gcc
LD = arm-none-eabi-gcc
STRIP = arm-none-eabi-strip
OBJCOPY = arm-none-eabi-objcopy
GAMBUILDER = gambuilder

# flags
SCFLAGS = -shared -fPIC -DSIMULATOR -I"./stdlib"
CFLAGS = -mcpu=cortex-m7 -Os -mfloat-abi=hard -mfpu=fpv5-sp-d16 -fmessage-length=0 -fsigned-char -ffreestanding -Wall -I"./stdlib"
LDFLAGS = -nostdlib -nostartfiles -s -T linker.ld

# defines
SRCS = $(wildcard *.c)
MAIN_ASM = main.S
OBJS := $(SRCS:.c=.o)
OBJ_ASM = __main_asm.o
TARGET = target/main.gam
TARGET_BIN = target/main.bin
TARGET_ELF = target/main.elf
TARGET_SIM = target/main.so

# code
all: $(TARGET)

$(TARGET_ELF): $(OBJS)
	$(CC) $(CFLAGS) $(MAIN_ASM) -o $(OBJ_ASM)
	$(LD) $(LDFLAGS) -o $@ $(OBJ_ASM) $^
	$(STRIP) --strip-all $@

$(TARGET_BIN): $(TARGET_ELF)
	$(OBJCOPY) -O binary $< $@

$(TARGET): $(TARGET_BIN)
	$(GAMBUILDER) -s makegam.lua -o $@ -b $<

simulator:
	$(SCC) $(SCFLAGS) -o $(TARGET_SIM)

%.o: %.c
	$(CC) $(CFLAGS) -c -o $@ $<

clean:
	rm -f $(OBJS) $(OBJ_ASM) $(TARGET) $(TARGET_BIN) $(TARGET_ELF) $(TARGET_SIM)

.PHONY: all clean

