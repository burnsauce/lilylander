disk: build/ll.prg
	@mkdir -p release
	@java -jar KickAss.jar -cfgfile "release.cfg" disk.asm

build/ll.prg: *.asm build/bgdata.asm build/titledata.asm build/font.asm
	@mkdir -p build
	@java -jar KickAss.jar -cfgfile "build.cfg" main.asm | tee build/memmap.txt
	@python cleanlabels.py
	@rm main.vs
	@python memmap.py | tee build/memlayout.txt

build/bgdata.asm: rle.py bg.gif
	@echo Rebuilding background data
	@python rle.py bg.gif > build/bgdata.asm
build/titledata.asm: rle.py title.gif
	@echo Rebuilding title data
	@python rle.py --prefix t_ --height 25 title.gif > build/titledata.asm
build/font.asm:	font.py nos.gif
	@echo Rebuilding font data
	@python font.py nos.gif > build/font.asm
clean:
	@rm -rf release/*.d64
	@rm -rf build/*
run: build/ll.prg
	@/c/Vice/x64sc -sound +warp build/ll.prg > /dev/null 2>&1 &
pal: build/ll.prg
	@/c/Vice/x64sc -sound +warp -pal build/ll.prg > /dev/null 2>&1 &
ntsc: build/ll.prg
	@/c/Vice/x64sc -sound +warp -ntsc build/ll.prg > /dev/null 2>&1 &
debug: build/ll.prg
	@/c/Vice/x64sc -sound +warp -moncommands build/main.vs build/ll.prg > /dev/null 2>&1 &


