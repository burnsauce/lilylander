#!python
from PIL import Image, ImageDraw

import argparse
height = 13

def main():
    p = argparse.ArgumentParser(
            description='Generate multiline data for C64 backgrounds')
    p.add_argument('--prefix', default="", help="data/segment prefix")
    p.add_argument('--height', default="13")
    p.add_argument('input')

    args = p.parse_args()
    prefix = args.prefix
    global height
    height = int(args.height)
    im = Image.open(args.input)

    size = im.size
    bgcol = 0
    for y in range(im.size[1]/8):
        for x in range(im.size[0]/4):
            colors = set()
            for y2 in range(8):
                for x2 in range(4):
                    colors.add(im.getpixel((x * 4 + x2, y * 8 + y2)))
            remain = 4
            if bgcol > 0:
                remain = 3
                if bgcol in colors:
                    colors.remove(bgcol)
            if len(colors) > remain:
                print 'Too many colors in cell', x,',', y
                print colors
    od = OutputData()
    if od.process(im) == False:
        return
    od.compress()
    od.printASM(prefix)

def rlencode(data):
    ret = []
    runcount = 0
    runbyte = None
    for i,v in enumerate(data):
        if runcount == 0:
            ret.append(v)
            runcount = 1
            runbyte = v
            continue
        if v == runbyte:
            if runcount == 1:
                ret.append(v)
            runcount += 1
            if runcount == 255:
                ret.append(runcount)
                runcount = 0
            continue
        if runcount > 1:
            ret.append(runcount)
        ret.append(v)
        runcount = 1
        runbyte = v
    if runcount > 1:
        ret.append(runcount)
    if ret[-1] == 0:
    	ret.extend([0, 1])
    ret.extend([0,0,0]) # ..0 == reset
    return ret

def rldecode(data):
    ret = []
    idx = 0
    while idx < len(data):
        if idx == len(data) - 1:
            ret.append(data[idx])
            return ret
        v1 = data[idx]
        idx += 1
        v2 = data[idx]
        if v2 == v1:
            idx += 1
            rl = data[idx]
            if rl == 0:
                return ret
            idx += 1
            for _ in range(rl):
                ret.append(v1)
        else:
            ret.append(v1)
    return ret

class Block:
    def __init__(self, data):
        self.data = [ d for d in data]
        self.bitmap = []


    def getcolors(self):
        ret = set()
        for d in self.data:
            ret.add(d)
        return ret

    def reindex(self, bg, mc1, mc2, rc):
        self.bg = bg
        self.mc1 = mc1
        self.mc2 = mc2
        self.rc = rc

        for d in self.data:
            if d == bg:
                self.bitmap.append(0)
            elif d == mc1:
                self.bitmap.append(1)
            elif d == mc2:
                self.bitmap.append(2)
            elif d == rc:
                self.bitmap.append(3)

    def encode(self):
        ret = []
        hibyte = 0
        lobyte = 0
        for (i, d) in enumerate(self.bitmap):
            if i % 4 == 0:
                hibyte = (d << 2)
            elif i % 4 == 1:
                hibyte += d
            elif i % 4 == 2:
                lobyte = (d << 2)
            else:
                lobyte += d
                ret.append(lobyte + (hibyte << 4))
        mat = self.mc2 + (self.mc1 << 4)
        ram = self.rc
        return (ret, mat, ram)

def printBytes(data):
        x = 0
        while x < len(data):
            if x % 8 == 0:
                print "\n\t.byte",
            else:
                print ",",
            print "$%02x" % data[x],
            x += 1
        print "\n"

        

class OutputData:
    bitmap = []
    screenmatrix = []
    ramdata = []

    def compress(self):
        self.bitmap = rlencode(self.bitmap)
        self.screenmatrix = rlencode(self.screenmatrix)
        self.ramdata = rlencode(self.ramdata)

    def process(self, im):
        rawblocks = []
        for y in range(im.size[1]/8):
            for x in range(im.size[0]/4):
                blockdata = []
                for y2 in range(8):
                    for x2 in range(4):
                        p = im.getpixel((x * 4 + x2, y * 8 + y2))
                        blockdata.append(p - 1)
                rawblocks.append(Block(blockdata))

        # identify background color
        bgcandidates = []
        for block in rawblocks:
            colors = block.getcolors()
            if len(colors) > 3:
                bgcandidates.append(colors)
        bgcolor = 0
        if len(bgcandidates) > 0:
            bgcandidates = set.intersection(*bgcandidates)
            if len(bgcandidates) < 1:
                print "Unable to find common color for background"
                return False
            bgcolor = list(bgcandidates)[0]
        self.bgcolor = bgcolor

        x = 0
        y = 0
        for block in rawblocks:
            colors = block.getcolors()
            if bgcolor in colors:
                colors.remove(bgcolor)
            colors = sorted(list(colors))
            matc1 = 0
            matc2 = 0
            ramc = 0
            if len(colors) > 0:
                matc1 = colors.pop()
            if len(colors) > 0:
                matc2 = colors.pop()
            if len(colors) > 0:
                ramc = colors.pop()

            block.reindex(bgcolor, matc1, matc2, ramc)
            bdata = block.encode()
            self.bitmap.append(bdata[0])
            self.screenmatrix.append(bdata[1])
            self.ramdata.append(bdata[2])

        # re-order data
        bm = []
        sm = []
        rd = []
        global height
        width = im.size[0] / 4
        for x in range(width):
            for y in range(height):
                bm.extend(self.bitmap[y * width + x])
                sm.append(self.screenmatrix[y * width + x])
                rd.append(self.ramdata[y * width + x])
        self.bitmap = bm
        self.screenmatrix = sm
        self.ramdata = rd
        return True

    def printASM(self, prefix):
        print '.segment RLEBitmap "RLE Bitmap"'
        print "%sbitmap:" % prefix
        printBytes(self.bitmap)
        print '.segment RLEMatrix "RLE Matrix"'
        print "%smatrix:" % prefix
        printBytes(self.screenmatrix)
        print '.segment RLEColor "RLE Color Ram"'
        print "%scolorram:" % prefix
        printBytes(self.ramdata)
        print "%sbgcolor:\t.byte" % prefix, self.bgcolor

        print "// Bitmap data size: $%04x" % len(self.bitmap)
        print "// Matrix data size: $%04x" % len(self.screenmatrix)
        print "//    Ram data size: $%04x" % len(self.ramdata)
		
        print "// Total size: $%04x bytes" % (len(self.bitmap) + len(self.screenmatrix) + len(self.ramdata))


if __name__ == '__main__':
    main()
