program=out/a

BUILD = hunk
# BUILD = elf

EMULATOR = amiberry
# EMULATOR = fsuae
# EMULATOR = quaesar
# EMULATOR = winuae

# Emulator options
MODEL = A500
FASTMEM = 0
CHIPMEM = 512
SLOWMEM = 512

ROM_PATH = $(HOME)/amiga/kickstarts/kick13.rom
BIN_DIR = $(HOME)/amiga/bin

# Binaries
CC = $(BIN_DIR)/bartman/opt/bin/m68k-amiga-elf-gcc
ELF2HUNK = $(BIN_DIR)/bartman/elf2hunk
VASM = $(BIN_DIR)/bartman/vasmm68k_mot
VLINK = $(BIN_DIR)/vlink

FSUAE = /Applications/FS-UAE.app/Contents/MacOS/fs-uae
AMIBERRY = /Applications/Amiberry.app/Contents/MacOS/Amiberry
QUAESAR = $(BIN_DIR)/quaesar

KINGCON = $(BIN_DIR)/kingcon
AMIGECONV = $(BIN_DIR)/amigeconv
WINUAE = wine $(BIN_DIR)/winuae.exe

# Flags:
VASMFLAGS = -m68000 -x
VLINKFLAGS = -bamigahunk -Bstatic
CCFLAGS = -g -MP -MMD -m68000 -Ofast -nostdlib -Wextra -fomit-frame-pointer -fno-tree-loop-distribution -flto -fwhole-program
LDFLAGS = -Wl,--emit-relocs,-Ttext=0
FSUAEFLAGS = --floppy_drive_0_sounds=off --automatic_input_grab=0  --chip_memory=$(CHIPMEM) --fast_memory=$(FASTMEM) --slow_memory=$(SLOWMEM) --amiga_model=$(MODEL) --console_debugger=1
AMIBERRYFLAGS = -s use_gui=false -s amiberry.active_capture_automatically=false -s warpboot=true -s log_illegal_mem=true -s cycle_exact=true
WINUAEFLAGS = -s use_gui=false -s win32.start_not_captured=true -s warpboot=true -s debug_mem=true -s cycle_exact=true

sources := main.asm
deps := $(addprefix out/, $(sources:.asm=.d)) # generated dependency makefiles

build_exe = $(program).$(BUILD).exe # unique exe filename for current build type
prog_exe = $(program).exe # generic name used in startup-sequence
# hunk build
hunk_exe = $(program).hunk.exe
hunk_debug = $(program).hunk-debug.exe
hunk_objects := $(addprefix out/, $(sources:.asm=.hunk))
# elf build
elf_exe = $(program).elf.exe
elf_linked = $(program).elf
elf_objects := $(addprefix out/, $(sources:.asm=.elf))

data =

.PHONY: all
all: $(build_exe)

.PHONY: run
run: run-$(EMULATOR)

.PHONY: run-fsuae
run-fsuae: $(build_exe)
	cp $< $(program).exe
	$(FSUAE) $(FSUAEFLAGS) --hard_drive_0=./out

.PHONY: run-amiberry
run-amiberry: $(build_exe)
	cp $< $(program).exe
	$(AMIBERRY) $(AMIBERRYFLAGS) -s filesystem2=rw,hd0:test:./out,0

.PHONY: run-quaesar
run-quaesar: $(build_exe)
	cp $< $(program).exe
	cd out; $(QUAESAR) $(notdir $(program).exe) --kickstart=$(ROM_PATH)

.PHONY: run-winuae
run-winuae: $(build_exe)
	cp $< $(program).exe
	$(WINUAE) $(WINUAEFLAGS) -s filesystem2=rw,hd0:test:$(CURDIR)/out,0 -s kickstart_rom_file=$(ROM_PATH)

.PHONY: clean
clean:
	$(RM) out/*.*

# BUILD=hunk (vasm/vlink)
$(hunk_exe): $(hunk_objects) $(hunk_debug)
	$(VLINK) $(VLINKFLAGS) -S $(hunk_objects) -o $@
	cp $@ $(prog_exe)
$(hunk_debug): $(hunk_objects)
	$(VLINK) $(VLINKFLAGS) $(hunk_objects) -o $@
out/%.hunk : %.asm $(data)
	$(VASM) $(VASMFLAGS) -Fhunk -linedebug -o $@ $<

# BUILD=elf (GCC/Bartman)
$(elf_exe): $(elf_linked)
	$(ELF2HUNK) $< $@ -s
	cp $@ $(prog_exe)
$(elf_linked): $(elf_objects)
	$(CC) $(CCFLAGS) $(LDFLAGS) $(elf_objects) -o $@
out/%.elf : %.asm $(data)
	$(VASM) $(VASMFLAGS) -Felf -dwarf=3 -o $@ $<

-include $(deps)

out/%.d : %.asm
	$(VASM) $(VASMFLAGS) -quiet -dependall=make -o "$(patsubst %.d,%.\$$(BUILD),$@)" $(CURDIR)/$< > $@