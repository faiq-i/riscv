import sys

filename = sys.argv[1]

f = open(filename, 'r')

lines = []

for line in f:
    lines.append(line)

f.close()
f = open(filename, 'w')

for line in lines:
    line = line.strip()
    f.write(line[0:2] + '\n')
    f.write(line[2:4] + '\n')
    f.write(line[4:6] + '\n')
    f.write(line[6:8] + '\n')

f.close()