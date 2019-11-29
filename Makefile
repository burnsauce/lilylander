ll.prg: *.asm bgdata.asm titledata.asm font.asm
	@java -jar KickAss.jar -cfgfile debug.cfg main.asm | tee memmap.txt	
	@python cleanlabels.py
	@python memmap.py | tee memlayout.txt

bgdata.asm: rle.py bg.gif
	@echo Rebuilding background data
	@python rle.py bg.gif > bgdata.asm
titledata.asm: rle.py title.gif
	@echo Rebuilding title data
	@python rle.py --prefix t_ --height 25 title.gif > titledata.asm
font.asm:	font.py nos.gif
	@echo Rebuilding font data
	@python font.py nos.gif > font.asm
clean:
	@rm -f *.prg
	@rm -f *.d64
	@rm -f bgdata.asm
	@rm -f titledata.asm
	@rm -f font.asm
run: ll.prg
	@/c/Vice/x64sc -sound +warp ll.prg > /dev/null 2>&1 &
pal: ll.prg
	@/c/Vice/x64sc -sound +warp -pal ll.prg > /dev/null 2>&1 &
ntsc: ll.prg
	@/c/Vice/x64sc -sound +warp -ntsc ll.prg > /dev/null 2>&1 &
debug: ll.prg
	@/c/Vice/x64sc -sound +warp -moncommands main.vs ll.prg > /dev/null 2>&1 &

unroll:
	@java -jar KickAss.jar -cfgfile unroll.cfg unroll.asm

disk:
	@java -jar KickAss.jar disk.asm

