Commands to configure the simulation environment:

- `vlib work`
- `vmap work work`

Command to compile testbench:

- `vlog -f files`

Commands to simulate testbench

- CLI  
`vsim -c -do "run -all;exit" nameTb`
- GUI, without format  
`vsim -do "add wave *;run -all" nameTb`
- GUI, with format  
`vsim -do nameFile.do nameTb`

> **environment variable**  
for compilation (`vlog`) with the option `-f file`, it is necessary to create the environment variable `BASICBLOCKS_SRC`, with the reference to the folder with the basic blocks  
example:  
`set BASICBLOCKS_SRC=/path/to/basicblocks`
