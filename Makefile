
###############################################################################
# Makefile for 430Chronos
###############################################################################


## General Flags
PROJECT = chronos
TARGET = $(BUILD_DIR)/$(PROJECT).elf
CC = msp430-gcc

MSPDEBUG = mspdebug
PROGFLAGS = rf2500 'opt fet_block_size 2048' 


## MCU to pass to the linker
MCU = cc430f6137

## C flags
CFLAGS := -Wall -Os -mmcu=$(MCU) -gdwarf-2

## Assembly flags
ASMFLAGS := -x assembler-with-cpp

## Linker flags
LDFLAGS = -mmcu=$(MCU) -Wl,-Map=$(TARGET:%.elf=%.map),--relax


SRC_DIR   := src
BUILD_DIR := build

## Do not edit below this line.


SRC       := $(foreach sdir,$(SRC_DIR),$(wildcard $(sdir)/*.c))
ASM       := $(foreach adir,$(SRC_DIR),$(wildcard $(adir)/*.s))

ASM_OBJ	  := $(patsubst src/%.s,build/%.o,$(ASM))

OBJ       = $(patsubst src/%.c,build/%.o,$(SRC))


DEP	  := $(OBJ:%.o=%.d)
INCLUDES  := $(addprefix -I,$(SRC_DIR))



all: checkdirs $(OBJ) $(ASM_OBJ) $(TARGET) size


#-include $(DEP)

checkdirs: $(BUILD_DIR)

clean:
	@rm -rf build/

# Build ASM src files
$(BUILD_DIR)/%.o : $(SRC_DIR)/%.s
	@echo "ASM" $(patsubst src/%.s,%.s,$<) " > " $(patsubst build/%.o,%.o,$@)
	@$(CC) $(INCLUDES) $(ASMFLAGS) -c $< -o $@
	@msp430-size $@

# Build dir must be built in order to compile
$(ASM_OBJ): | $(BUILD_DIR)

# Build C src files
$(BUILD_DIR)/%.o : $(SRC_DIR)/%.c
	@echo "CC " $(patsubst src/%.c,%.c,$<) " > " $(patsubst build/%.o,%.o,$@)
	@$(CC) $(INCLUDES) $(CFLAGS) -c $< -MD -o $@
	@msp430-size $@

# Build dir must be built in order to compile	
$(OBJ): | $(BUILD_DIR)


$(BUILD_DIR):
	@mkdir -p $@
	
# Compile *.elf target from objects	
$(TARGET): $(OBJ) $(ASM_OBJ)
	@echo "=========================="
	@echo "$(patsubst build/%.o,%.o,$^) >" $(patsubst build/%.elf,%.elf,$@)
	@$(CC) $(LDFLAGS) $(LIBDIRS) $(LIBS) $^ -o $@
	@echo "=========================="

size: $(TARGET)
#	@echo
	@msp430-size ${TARGET}

prog: $(TARGET)
	$(MSPDEBUG) $(PROGFLAGS) 'prog $<'


