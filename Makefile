main.prg: main.asm frame.asm game.asm common.asm sprites.asm \
		sprlib.asm bg.asm sid.asm
	java -jar KickAss.jar -cfgfile build.cfg main.asm
clean:
	rm *.prg
run:
	java -jar KickAss.jar -cfgfile run.cfg main.asm
debug:
	java -jar KickAss.jar -cfgfile debug.cfg main.asm
