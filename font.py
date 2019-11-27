#!python
# :vim ts=4
from PIL import Image, ImageDraw

import argparse

def main():
    p = argparse.ArgumentParser(
            description='Generate multiline data for C64 backgrounds')
    p.add_argument('input')

    args = p.parse_args()
    im = Image.open(args.input)

    size = im.size
    fontbitmap = []
    for y in range(10):
        nbitmap = []
        for y2 in range(5):
            bitmap = [ (0 if n % 2 == 0 else 1) for n in range(8) ]
            for x in range(3):
                p = im.getpixel((x, y * 5 + y2))
                if p != 0:
                    bitmap[x * 2] = 1 
                    bitmap[x * 2 + 1] = 1 
            byte = sum([ (1 << (7-i)) for i,n in enumerate(bitmap) if n == 1 ])
            nbitmap.append(byte)
        fontbitmap.append(nbitmap)
    print 'font_numerals:'
    for i,b in enumerate(fontbitmap):
        print '.byte $%02x,' % b[0],
        for n in b[1:-1]:
            print '$%02x,' % n,
        print '$%02x' % b[-1]
        print '.fill 3, 0'
	

if __name__ == "__main__":
    main()
