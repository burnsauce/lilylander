#!python
from PIL import Image, ImageDraw

import argparse

def main():
    p = argparse.ArgumentParser(
            description='Generate multiline data for C64 backgrounds')
    p.add_argument('input')

    args = p.parse_args()
    im = Image.open(args.input)
    size = im.size
    bgcolors = []
    """
    for y in range(im.size[1]):
        colors = set()
        for x in range(im.size[0]):
            colors.add(im.getpixel((x,y)))
        if len(colors) > 5:
            print 'Too many colors on line', y
            print colors
            #exit()
        bgcolors.append(colors)
    """ 
    for y in range(im.size[1]/8):
        for x in range(im.size[0]/4):
            colors = set()
            for y2 in range(8):
                for x2 in range(4):
                    colors.add(im.getpixel((x * 4 + x2, y * 8 + y2)))
            if len(colors) > 5:
                print 'Too many colors in cell', x,',', y
                print colors
    """
    for y in range(im.size[1]):
        for x in range(im.size[0]/2):
            c1 = im.getpixel((x * 2, y))
            c2 = im.getpixel((x * 2 + 1, y))
            if not c2 == c1:
                print c1, c2
                print 'Two-pixel quantization failed at pixel', x * 2, ',', y
    """

if __name__ == '__main__':
    main()
