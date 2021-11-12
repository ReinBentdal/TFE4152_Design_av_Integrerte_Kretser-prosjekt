# -Wall gjør at flere detaljer blir printet til konsollen
sim:
	iverilog -g2012 -Wall -o output/pixelSensor.out pixelSensor_tb.sv
	vvp -n output/pixelSensor.out

sv2v:
	sv2v --define=synthesize --write=output/pixelSensor.v pixelSensor.sv
	find . -name 'pixelSensor.v' -print0 | xargs -0 sed -i "" "s/PixelSensorConfig_//g"

synth:
	yosys pixelSensor.ys

# include nesecary library in netlist file
	sed -i "" '1{h;s/.*//;G;}' output/pixelSensor_netlist.v
	sed -i "" '1{h;s/.*/`include "..\/..\/..\/lib\/gates.lib"/;G;}' output/pixelSensor_netlist.v
	sed -i "" '1{h;s/.*/\/\/ **Custom imports** /;G;}' output/pixelSensor_netlist.v

# log circuit components count
	$(eval dffsr=$(shell cat output/pixelSensor_netlist.v |grep DFFSR|wc -l))
	$(eval dff=$(shell cat output/pixelSensor_netlist.v |grep DFF|wc -l))
	$(eval nand=$(shell cat output/pixelSensor_netlist.v|grep '& ~'|wc -l))
	$(eval and=$(shell cat output/pixelSensor_netlist.v|grep -E '& ([^~]|$$)'|wc -l))
	$(eval nor=$(shell cat output/pixelSensor_netlist.v|grep '\| ~'|wc -l))
	$(eval or=$(shell cat output/pixelSensor_netlist.v|grep -E '\| ([^~]|$$)'|wc -l))
	$(eval datestring=$(shell date +%FT%T))
	sed -i "" '1{h;s/.*/'$(datestring)' dffsr: '$(dffsr)', dff: '$(dff)', and: '$(and)', nand: '$(nand)', or: '$(or)', nor: '$(nor)'/;G;}' output/component_count.log

	find . -name 'pixelSensor.json' -print0 | xargs -0 sed -i "" "s/NAND/\$$$ nand/g"
	find . -name 'pixelSensor.json' -print0 | xargs -0 sed -i "" "s/NOT/\$$$ not/g"

svg:
	netlistsvg output/pixelSensor.json -o output/pixelSensor_diagram.svg

synth_all:
	${MAKE} sv2v
	${MAKE} synth
	${MAKE} svg