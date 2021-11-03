# sensor state
sim:
	iverilog -g2012 -Wall -o sensorTop.out sensorTop_tb.sv
	vvp -n sensorTop.out

# simulates netlist
simnet:
	iverilog -DNETLIST -g2012 -Wall -o sensorTop.out sensorTop_tb.sv
	vvp -n sensorTop.out	

# synthesizes and then simulates the generated netlist
synthsim:
	${MAKE} sv2v 
	${MAKE} synth 
	${MAKE} simnet 

sv2v:
	sv2v --define=synthesize --write=output/sensorTop.v sensorTop.sv

# fixes one naming bug
	find . -name 'sensorTop.v' -print0 | xargs -0 sed -i "" "s/PixelSensorConfig_//g"

svg:
#	rm output/sensorTop_diagram.svg
	netlistsvg sensorTop.json -o output/sensorTop_diagram.svg --config diagram_conf.json

synth:
	yosys sensorTop.ys
	
# include nesecary library
	sed -i "" '1{h;s/.*//;G;}' sensorTop_netlist.v
	sed -i "" '1{h;s/.*/`include "..\/..\/lib\/gates.v"/;G;}' sensorTop_netlist.v
	sed -i "" '1{h;s/.*/`include "..\/pixel_sensor\/pixelSensorAnalog.sv"/;G;}' sensorTop_netlist.v
	sed -i "" '1{h;s/.*/\/\/ **Custom imports** /;G;}' sensorTop_netlist.v

# log circuit components count
	sleep 1
	$(eval dffsr=$(shell cat sensorTop_netlist.v |grep -w DFFSR|wc -l))
	$(eval dff=$(shell cat sensorTop_netlist.v |grep -w DFF|wc -l))
	$(eval nand=$(shell cat sensorTop_netlist.v|grep -w NAND|wc -l))
	$(eval and=$(shell cat sensorTop_netlist.v|grep -w AND|wc -l))
	$(eval nor=$(shell cat sensorTop_netlist.v|grep -w NOR|wc -l))
	$(eval or=$(shell cat sensorTop_netlist.v|grep -w OR|wc -l))
	$(eval datestring=$(shell date +%FT%T))
	sed -i "" '1{h;s/.*/'$(datestring)' dffsr: '$(dffsr)', dff: '$(dff)', and: '$(and)', nand: '$(nand)', or: '$(or)', nor: '$(nor)'/;G;}' component_count.log

all:
	${MAKE} sv2v;
	${MAKE} synth;
	${MAKE} svg;