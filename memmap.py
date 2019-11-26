#
# vim: set ts=4:
labels = {}
rawlines = []
import re

blocks = {}

p = re.compile(r'  \*?\$([0-9a-f]{4})-\$([0-9a-f]{4}) (.*)')

with open("memmap.txt", "r") as f:
	for line in f:
		m = p.match(line)
		if m != None:
			mb = blocks.setdefault(int(m.group(1), 16),[])
			mb.append((int(m.group(1), 16), int(m.group(2), 16), m.group(3)))

i = 0x200
for block in sorted(blocks.keys()):
	if block > i:
		print "\t%5d bytes free at $%04x" % (block - i, i)
	for mb in blocks[block]:
			print "$%04x-$%04x %s" % mb
	i = max([b[1] for b in blocks[block]]) + 1

print "\t%5d bytes free at $%04x" % (0xfffe - i, i)
