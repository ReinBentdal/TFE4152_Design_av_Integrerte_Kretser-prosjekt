# sensor state
sim:
	iverilog -g2012 -Wall -o sensorTop.out sensorTop_tb.sv
	vvp -n sensorTop.out

synth:

	yosys sensorTop.ys
	
# include nesecary library
	sed -i "" '1{h;s/.*//;G;}' sensorTop_netlist.sv
	sed -i "" '1{h;s/.*/`include "gates.v"/;G;}' sensorTop_netlist.sv
	sed -i "" '1{h;s/.*/\/\/ **Custom imports** /;G;}' sensorTop_netlist.sv

# create circuit diagram
#	rm sensorTop_diagram.svg
#	netlistsvg sensorTop.json -o sensorTop_diagram.svg

# log circuit components count
	$(eval dffsr=$(shell cat sensorTop_netlist.v |grep DFFSR|wc -l))
	$(eval dff=$(shell cat sensorTop_netlist.v |grep DFF|wc -l))
	$(eval nand=$(shell cat sensorTop_netlist.v|grep '& ~'|wc -l))
	$(eval and=$(shell cat sensorTop_netlist.v|grep -E '& ([^~]|$$)'|wc -l))
	$(eval nor=$(shell cat sensorTop_netlist.v|grep '\| ~'|wc -l))
	$(eval or=$(shell cat sensorTop_netlist.v|grep -E '\| ([^~]|$$)'|wc -l))
	$(eval datestring=$(shell date +%FT%T))
	sed -i "" '1{h;s/.*/'$(datestring)' dffsr: '$(dffsr)', dff: '$(dff)', and: '$(and)', nand: '$(nand)', or: '$(or)', nor: '$(nor)'/;G;}' component_count.log