import re
import subprocess
import sys
from os import system

p = re.compile('!src "(.*)"')
included = []

def expand(infile, outfile):
    if infile in included:
        return
    print "Including ", infile
    included.append(infile)
    outfile.write("\n; included from %s\n" % infile)
    with open(infile, "r") as f:
        for line in f:
            m = p.match(line)
            if m:
                expand(m.group(1), outfile)
            else:
                outfile.write(line)
def main():
    print "Preprocessing assembly files..."
    with open("full.asm", "w") as outf:
        expand("main.asm", outf)
    print "Done preprocessing."
    r = None
    oargs = [r"C:\C64StudioRelease\acme\acme.exe", 
                "-o", "main.prg", "-v2",
                "-f", "cbm", "-l", "main.txt", "full.asm"]
    try:
        r = subprocess.check_output(oargs, stderr=subprocess.STDOUT)
    except:
        r = system(" ".join(oargs))
        print "Compile failed!"
        sys.exit(1)


    lines = []
    with open("main.txt", "r") as f:
        lines = sorted(list(f))
    with open("main.txt", "w") as f:
        for line in lines:
            f.write(line)
    for line in r.split('\n'):
        print line


    sys.exit()

if __name__ == "__main__":
    main()
