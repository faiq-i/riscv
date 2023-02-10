rmdir -r build
mkdir build

riscv64-unknown-elf-as -c -o build/object.o %1 -march=rv32i -mabi=ilp32

riscv64-unknown-elf-gcc -o build/elf.elf build/object.o -T C:/global/linker.ld -nostdlib -march=rv32i -mabi=ilp32

riscv64-unknown-elf-objcopy -O binary --only-section=.data* --only-section=.text* build/elf.elf build/bin.bin

python maketxt.py build/bin.bin > %2

python makebyteaddr.py %2

rmdir -r build