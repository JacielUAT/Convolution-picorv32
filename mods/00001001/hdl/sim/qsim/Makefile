PROJ=ID00001001_dummy
TOP=${PROJ}Tb

all: ${PROJ}.sim

syn ${PROJ}.syn : ${PROJ}.files ## Synthesis
	vlog -f $< -sv -timescale "10ns/1ns"
#iverilog -c $< -g2012 -o ${PROJ}.smf -s ${TOP}

sim ${PROJ}.sim : ${PROJ}.syn ## Simulation
	vsim -do ${PROJ}.do ${TOP} -voptargs=+acc
#vvp ${PROJ}.smf

.PHONY : clean help

clean: ## Clear workspace
	rm -rf work *.wlf transcript

help : ## Help
	@fgrep -h "##" $(MAKEFILE_LIST) | sed -e 's/\(\:.*\#\#\)/\:\ /' | fgrep -v fgrep | sed -e 's/\\$$//' | sed -e 's/##//'