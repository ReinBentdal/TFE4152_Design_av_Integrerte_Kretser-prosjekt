# sensor state
sim:
	iverilog -g2012 -Wall -o output/sensorState.out sensorState_tb.sv
	vvp -n output/sensorState.out

synth:

	yosys sensorState.ys
	
# include nesecary library in netlist file
	sed -i "" '1{h;s/.*//;G;}' output/sensorState_netlist.sv
	sed -i "" '1{h;s/.*/`include "..\/..\/..\/lib\/gates.lib"/;G;}' output/sensorState_netlist.sv
	sed -i "" '1{h;s/.*/\/\/ **Custom imports** /;G;}' output/sensorState_netlist.sv

# create circuit diagram
# rm output/sensorState_diagram.svg
	netlistsvg output/sensorState.json -o output/sensorState_diagram.svg

# log circuit components count
	$(eval dffsr=$(shell cat output/sensorState_netlist.v |grep DFFSR|wc -l))
	$(eval dff=$(shell cat output/sensorState_netlist.v |grep DFF|wc -l))
	$(eval nand=$(shell cat output/sensorState_netlist.v|grep '& ~'|wc -l))
	$(eval and=$(shell cat output/sensorState_netlist.v|grep -E '& ([^~]|$$)'|wc -l))
	$(eval nor=$(shell cat output/sensorState_netlist.v|grep '\| ~'|wc -l))
	$(eval or=$(shell cat output/sensorState_netlist.v|grep -E '\| ([^~]|$$)'|wc -l))
	$(eval datestring=$(shell date +%FT%T))
	sed -i "" '1{h;s/.*/'$(datestring)' dffsr: '$(dffsr)', dff: '$(dff)', and: '$(and)', nand: '$(nand)', or: '$(or)', nor: '$(nor)'/;G;}' output/component_count.log

sv2v:
	sv2v --define=synthesize --define=PIXEL_WIDTH=${PW} --define=PIXEL_HEIGHT=${PH} --write=output/sensorState.v sensorState.sv

# fixes one naming bug
	find . -name 'sensorState.v' -print0 | xargs -0 sed -i "" "s/PixelSensorConfig_//g"