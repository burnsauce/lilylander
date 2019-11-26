ll.prg: *.asm bgdata.asm
	java -jar KickAss.jar -cfgfile debug.cfg main.asm > memmap.txt	
	python cleanlabels.py
	python memmap.py

bgdata.asm: rle.py bg.gif
	python rle.py bg.gif > bgdata.asm

clean:
	rm *.prg
run: ll.prg
	/c/Vice/x64sc -sound +warp ll.prg &
debug: ll.prg
	/c/Vice/x64sc -sound +warp -moncommands main.vs ll.prg &

unroll:
	java -jar KickAss.jar -cfgfile unroll.cfg unroll.asm

disk:
	java -jar KickAss.jar disk.asm
