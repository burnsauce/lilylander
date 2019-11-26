main.prg: *.asm
	java -jar KickAss.jar -cfgfile build.cfg main.asm > memmap.txt	
	python memmap.py
clean:
	rm *.prg
run:
	java -jar KickAss.jar -cfgfile run.cfg main.asm
debug:
	java -jar KickAss.jar -cfgfile debug.cfg main.asm
	python cleanlabels.py
	/c/Vice/x64sc -sound +warp -moncommands main.vs ll.prg

unroll:
	java -jar KickAss.jar -cfgfile unroll.cfg unroll.asm
