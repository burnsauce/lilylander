
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

with open("main.vs", "w") as f:
	for addr in sorted(labels.keys()):
		if len(labels[addr]) > 1:
			for label in labels[addr]:
				if label.startswith('.zp'):
					continue
				if len(label) > 1:
					f.write('al C:%04x %s\n' % (addr, label))

		else:	
			f.write('al C:%04x %s\n' % (addr, labels[addr][0]))
	for line in rawlines:
		f.write(line)

