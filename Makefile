# Project dependencies
PROJECT := final

# Build tools
CC=arm-none-eabi-gcc
CP=arm-none-eabi-objcopy

# Compiler options
CFLAGS  = -ggdb -O0 -Wall -Wextra -Warray-bounds -mlittle-endian
CFLAGS  += -mthumb -mcpu=cortex-m3 -mthumb-interwork

# Linker file / options
LFLAGS  = -T $(wildcard *.ld)
LFLAGS += --specs=nano.specs --specs=nosys.specs 
LFLAGS += -Wl,-Map -Wl,$(PROJECT).map

# Directories to be searched for header files
INCLUDE = -I../../STM32F10x_StdPeriph_Lib_V3.5.0/Libraries/CMSIS/CM3/CoreSupport/ 
INCLUDE += -I../../STM32F10x_StdPeriph_Lib_V3.5.0/Libraries/STM32F10x_StdPeriph_Driver/inc/
INCLUDE += -I./

# Object files to be created
OBJECTS = $(patsubst %.c, %.o, $(wildcard *.c)) $(patsubst %.s, %.o, $(wildcard *.s))

# Add Standard Peripheral Library to the build configuration
DEFS    = -DUSE_STDPERIPH_DRIVER

# Build targets
.PHONY: all
all: $(PROJECT).elf

%.o: %.c
	$(CC) $(INCLUDE) $(DEFS) $(CFLAGS) -c $< -o $@

%.o: %.s
	$(CC) $(INCLUDE) $(CFLAGS) -c $< -o $@ 

$(PROJECT).elf: $(OBJECTS)
	$(CC) $(INCLUDE) $(DEFS) $(CFLAGS) $(LFLAGS) -o $@ $(OBJECTS)
	$(CP) -O binary $(PROJECT).elf $(PROJECT).bin

.PHONY: clean
clean:
	rm *.o *.bin *.elf *.map
	
load:
	openocd -f ../../boards/bluepill.cfg

gdb:
	arm-none-eabi-gdb 
	
	#target remote localhost:3333
	#monitor reset init
	#monitor flash write_image erase final.elf	
	#monitor reset halt
	#monitor resume
	
flash:
	openocd -f interface/stlink-v2.cfg -f target/stm32f1x.cfg -c "program final.elf verify reset exit"