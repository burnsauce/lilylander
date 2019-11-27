#
# vim: set ts=4:
labels = {}
rawlines = []
import re

print
print "   Memory Allocation"
print
blocks = {}

p = re.compile(r'  \*?\$([0-9a-f]{4})-\$([0-9a-f]{4}) (.*)')

with open("memmap.txt", "r") as f:
	for line in f:
		m = p.match(line)
		if m != None:
			mb = blocks.setdefault(int(m.group(1), 16),[])
			mb.append((int(m.group(1), 16), int(m.group(2), 16), m.group(3)))

i = 0x200
freebytes = 0
for block in sorted(blocks.keys()):
	if block > i:
		print "\t%5d bytes free at $%04x" % (block - i, i)
		freebytes += block - i
	for mb in blocks[block]:
			l = "$%04x-$%04x %s" % mb
			l2 = "%%%dd bytes" % (40 - len(l))
			print l, l2 % (mb[1] - mb[0] + 1)
	i = max([b[1] for b in blocks[block]]) + 1


print "\t%5d bytes free at $%04x" % (0xfffe - i, i)
print "\t%5d total bytes free" % (freebytes)
