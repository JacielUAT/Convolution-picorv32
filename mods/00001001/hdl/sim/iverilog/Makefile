PROJECT = ID00001001_dummy
TOPMODULE ?= ${PROJECT}Tb

VERILOG_FILES:=$(shell cat ${PROJECT}.files | sed 's/.* //')

GTKW_FILE = $(shell [ -f ./$(TOPMODULE).gtkw ] && echo 1 || echo 0 )


all: sim

syn : ${TOPMODULE}.vvp ## Synthesis with iverilog

sim : ${TOPMODULE}.vcd  ## Simulation with iverilog

%.vvp : ${VERILOG_FILES}
	iverilog -c${PROJECT}.files -g2012 -o${TOPMODULE}.vvp -s${TOPMODULE} -DIVERILOG

%.vcd : ${TOPMODULE}.vvp
	vvp -l${TOPMODULE}.log $(TOPMODULE).vvp -lxt2 

wvf : ${TOPMODULE}.vcd ## Show waveforms with GTK Wave
ifeq ($(GTKW_FILE), 1)
	gtkwave ${TOPMODULE}.vcd ${TOPMODULE}.gtkw &
else
	gtkwave ${TOPMODULE}.vcd &
endif

cls : ## Clean workspace
	rm -rf *.vcd *.vvp *.log

help : ## Help
	@fgrep -h "##" $(MAKEFILE_LIST) | sed -e 's/\(\:.*\#\#\)/\:\ /' | fgrep -v fgrep | sed -e 's/\\$$//' | sed -e 's/##//'

info : ## Show source files
	@echo "Files checking:\n" $(foreach file,${VERILOG_FILES},"${file}\n")

.PHONY: cls
