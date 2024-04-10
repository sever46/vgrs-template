# compiler
SCC = gcc
CC = arm-none-eabi-gcc
LD = arm-none-eabi-gcc
STRIP = arm-none-eabi-strip
OBJCOPY = arm-none-eabi-objcopy
GAMBUILDER = gambuilder

# flags
SCFLAGS = -shared -fPIC -DSIMULATOR 
CFLAGS = -mcpu=cortex-m7 -Os -mfloat-abi=hard -mfpu=fpv5-sp-d16 -fmessage-length=0 -fsigned-char -ffreestanding -Wall
LDFLAGS = -nostdlib -nostartfiles -s -T linker.ld

# defines
SRCS = $(wildcard *.c)
OBJS := $(SRCS:.c=.o)
TARGET = target/main.gam
TARGET_BIN = target/main.bin
TARGET_ELF = target/main.elf
TARGET_SIM = target/main.so

# code
all: $(TARGET)

$(TARGET_ELF): $(OBJS)
	$(LD) $(LDFLAGS) -o $@ $^
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
	rm -f $(OBJS) $(TARGET) $(TARGET_BIN) $(TARGET_ELF) $(TARGET_SIM)

.PHONY: all clean

