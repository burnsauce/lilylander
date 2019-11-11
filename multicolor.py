#!python
from PIL import Image, ImageDraw

import argparse

class RGB:
    def __init__(self, t):
        self.r = int(t[0])
        self.g = int(t[1])
        self.b = int(t[2])
    def __eq__(self, other):
        if not isinstance(other, RGB):
            return NotImplemented
        return (self.r == other.r and self.g == other.g and self.b == other.b)
    def __hash__(self):
        s = (self.r, self.g, self.b)
        return hash(s)
    def __str__(self):
        return "(%d, %d, %d)" % (self.r, self.g, self.b)

def main():
    p = argparse.ArgumentParser(
            description='Generate multiline data for C64 backgrounds')
    p.add_argument('input')

    args = p.parse_args()
    im = Image.open(args.input)
    size = im.size
    bgcolors = []

    for y in range(im.size[1]):
        colors = set()
        for x in range(im.size[0]):
            colors.add(RGB(im.getpixel((x,y))))
        if len(colors) > 4:
            print 'Too many colors on line', y
            #exit()
        bgcolors.append(colors)
    
    for y in range(im.size[1]/8):
        for x in range(im.size[0]/8):
            colors = set()
            for y2 in range(8):
                for x2 in range(8):
                    colors.add(RGB(im.getpixel((x * 8 + x2, y * 8 + y2))))
            if len(colors) > 4:
                print 'Too many colors in cell', x,',', y

    for y in range(im.size[1]):
        for x in range(im.size[0]/2):
            c1 = RGB(im.getpixel((x * 2, y)))
            c2 = RGB(im.getpixel((x * 2 + 1, y)))
            if not c2 == c1:
                print c1, c2
                print 'Two-pixel quantization failed at pixel', x * 2, ',', y


if __name__ == '__main__':
    main()
