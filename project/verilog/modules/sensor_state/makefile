# sensor state
ss:
	iverilog -g2012 -Wall -o sensorState.out sensorState_tb.sv
	vvp -n sensorState.out

synth:

	yosys sensorState.ys
	
# include nesecary library in netlist file
	sed -i "" '1{h;s/.*//;G;}' sensorState_netlist.sv
	sed -i "" '1{h;s/.*/`include "..\/..\/..\/lib\/gates.lib"/;G;}' sensorState_netlist.sv
	sed -i "" '1{h;s/.*/\/\/ **Custom imports** /;G;}' sensorState_netlist.sv

# create circuit diagram
	rm sensorState_diagram.svg
	netlistsvg sensorState.json -o sensorState_diagram.svg

# log circuit components count
	$(eval dffsr=$(shell cat sensorState_netlist.v |grep DFFSR|wc -l))
	$(eval dff=$(shell cat sensorState_netlist.v |grep DFF|wc -l))
	$(eval nand=$(shell cat sensorState_netlist.v|grep '& ~'|wc -l))
	$(eval and=$(shell cat sensorState_netlist.v|grep -E '& ([^~]|$$)'|wc -l))
	$(eval nor=$(shell cat sensorState_netlist.v|grep '\| ~'|wc -l))
	$(eval or=$(shell cat sensorState_netlist.v|grep -E '\| ([^~]|$$)'|wc -l))
	$(eval datestring=$(shell date +%FT%T))
	sed -i "" '1{h;s/.*/'$(datestring)' dffsr: '$(dffsr)', dff: '$(dff)', and: '$(and)', nand: '$(nand)', or: '$(or)', nor: '$(nor)'/;G;}' component_count.log