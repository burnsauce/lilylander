main.prg: *.asm
	java -jar KickAss.jar -cfgfile build.cfg main.asm
clean:
	rm *.prg
run:
	java -jar KickAss.jar -cfgfile run.cfg main.asm
debug:
	java -jar KickAss.jar -cfgfile debug.cfg main.asm
unroll:
	java -jar KickAss.jar -cfgfile unroll.cfg unroll.asm
