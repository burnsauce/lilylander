main.prg: main.asm frame.asm game.asm common.asm sprites.asm \
		sprlib.asm
	java -jar KickAss.jar main.asm
clean: *
	rm *.prg
