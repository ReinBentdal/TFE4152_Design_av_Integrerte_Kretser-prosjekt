# -Wall gjør at flere detaljer blir printet til konsollen
sim:
	iverilog -g2012 -Wall -o output/pixelSensor.out pixelSensor_tb.sv
	vvp -n output/pixelSensor.out

sv2v:
	sv2v --define=synthesize --write=output/pixelSensor.v pixelSensor.sv

ifeq ($(shell uname),Darwin)
	find . -name 'pixelSensor.v' -print0 | xargs -0 sed -i "" "s/PixelSensorConfig_//g"
else
	sed -i "s/PixelSensorConfig_//g" output/pixelSensor.v
endif

synth:
	yosys pixelSensor.ys

# include nesecary library in netlist file
ifeq ($(shell uname), Darwin)
	sed -i "" '1{h;s/.*//;G;}' output/pixelSensor_netlist.v
	sed -i "" '1{h;s/.*/`include "..\/..\/..\/lib\/gates.lib"/;G;}' output/pixelSensor_netlist.v
	sed -i "" '1{h;s/.*/\/\/ **Custom imports** /;G;}' output/pixelSensor_netlist.v
else
	sed -i '1{h;s/.*//;G;}' output/pixelSensor_netlist.v
	sed -i '1{h;s/.*/`include "..\/..\/..\/lib\/gates.lib"/;G;}' output/pixelSensor_netlist.v
	sed -i '1{h;s/.*/\/\/ **Custom imports** /;G;}' output/pixelSensor_netlist.v
endif

# log circuit components count
	$(eval dffsr=$(shell cat output/pixelSensor_netlist.v |grep DFFSR|wc -l))
	$(eval dff=$(shell cat output/pixelSensor_netlist.v |grep DFF|wc -l))
	$(eval nand=$(shell cat output/pixelSensor_netlist.v|grep '& ~'|wc -l))
	$(eval and=$(shell cat output/pixelSensor_netlist.v|grep -E '& ([^~]|$$)'|wc -l))
	$(eval nor=$(shell cat output/pixelSensor_netlist.v|grep '\| ~'|wc -l))
	$(eval or=$(shell cat output/pixelSensor_netlist.v|grep -E '\| ([^~]|$$)'|wc -l))
	$(eval datestring=$(shell date +%FT%T))

ifeq ($(shell uname), Darwin)
	sed -i "" '1{h;s/.*/'$(datestring)' dffsr: '$(dffsr)', dff: '$(dff)', and: '$(and)', nand: '$(nand)', or: '$(or)', nor: '$(nor)'/;G;}' output/component_count.log
else
	sed -i '1{h;s/.*/'$(datestring)' dffsr: '$(dffsr)', dff: '$(dff)', and: '$(and)', nand: '$(nand)', or: '$(or)', nor: '$(nor)'/;G;}' output/component_count.log
endif

svg:
	netlistsvg output/pixelSensor.json -o output/pixelSensor_diagram.svg

synth_all:
	${MAKE} sv2v
	${MAKE} synth
	${MAKE} svg