#
# vim: set ts=4:
labels = {}
rawlines = []

with open("main.vs", "r") as f:
	for line in f:
		(cmd, caddr, label) = line.split(" ")
		if cmd == 'al':
		    addr = int(caddr[2:], 16)
		    labels.setdefault(addr, []).append(label[:-1])
		else:
			rawlines.append(line)

with open("build/main.vs", "w") as f:
	lastlbl=""
	zpcount=0
	wzcount=0
	zplast=False
	for addr in sorted(labels.keys()):
		
		if len(labels[addr]) > 1:
			for label in sorted(labels[addr]):
				if label.startswith('.zplast'):
					zplast=True
				if label.startswith('.zp') and not zplast:
					zpcount += 1
					print '%04x: %s_%d' % (addr, lastlbl, zpcount)
					continue
				elif not zplast:
					f.write('al C:%04x %s\n' % (addr, label))
					zpcount = 0
					lastlbl = label
		elif labels[addr][0].startswith('.zplast'):
			zplast=True
			
		elif labels[addr][0].startswith('.zp') and not zplast:
			zpcount += 1
			f.write('al C:%04x %s_%d\n' % (addr, lastlbl, zpcount))
		elif not labels[addr][0].startswith('.zp'):	
			f.write('al C:%04x %s\n' % (addr, labels[addr][0]))
			zpcount = 0
			lastlbl=""
	for line in rawlines:
		f.write(line)

