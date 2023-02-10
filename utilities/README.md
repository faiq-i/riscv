# Utilities

These are some Python scripts and a batch file which were made only for faster working during testing. The basic idea is that I write a RISC-V Assembly code (such as `code.s`) and then compile it using the <a href="https://github.com/riscv-collab/riscv-gnu-toolchain">RISC-V GNU Toolchain</a>. The compiled machine code is then converted to hexadecimal and written to a file one byte per line (only to simulate a byte-addressable memory which I use in this project). The tasks performed b each script is as follow:

- `maketxt.py`: Makes a .txt file from the .bin file containing the machine code.
- `txt2hex.py`: Converts the binary text into hexadecimal
- `makebyteaddr.py`: Converts the hexadecimal file into another hexadecimal file with one byte per line
- `makerisc.bat`: The batch file that combines all scripts into a single place. It first compiles the assembly code using the RISC-V GNU Toolchain, then uses the Python scripts to store the instructions to any file specified by the user (such as `ins.mem`).


## Usage

```
./makerisc.bat /path/to/assembly/code /path/to/destination/file
```

For example, the above files are created using the command.

```
./makerisc.bat code.s ins.mem
```

You can also add the scripts to your environment variables and simply use `makerisc` as a command.
