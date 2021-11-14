PW?=24
PH?=12

plot:
	python3 scene/txt_to_img.py ${PW} ${PH}

# sensor state
sim:
	iverilog -DPIXEL_WIDTH=${PW} -DPIXEL_HEIGHT=${PH} -g2012 -Wall -o output/sensorTop.out sensorTop_tb.sv
	vvp -n output/sensorTop.out

# simulates netlist
simnet:
	iverilog -DNETLIST -g2012 -Wall -o output/sensorTop.out sensorTop_tb.sv
	vvp -n output/sensorTop.out

# synthesizes and then simulates the generated netlist
synthsim:
	${MAKE} sv2v PW=${PW} PH=${PH}
	${MAKE} synth
	${MAKE} simnet

sv2v:
	sv2v --define=synthesize --define=PIXEL_WIDTH=${PW} --define=PIXEL_HEIGHT=${PH} --write=output/sensorTop.v sensorTop.sv

# fixes one naming bug
	find . -name 'sensorTop.v' -print0 | xargs -0 sed -i "" "s/PixelSensorConfig_//g"

svg:
#	rm output/sensorTop_diagram.svg
	netlistsvg output/sensorTop.json -o output/sensorTop_diagram.svg --config netlistsvg_conf.json

synth:
# -q -q to prevent console logging, may help with compile speed
	yosys -q -q sensorTop.ys
	
# include nesecary library
	sed -i "" '1{h;s/.*//;G;}' output/sensorTop_netlist.v
	sed -i "" '1{h;s/.*/`include "..\/..\/lib\/gates.v"/;G;}' output/sensorTop_netlist.v
	sed -i "" '1{h;s/.*/`include "..\/..\/pixel_sensor\/pixelSensorAnalog.sv"/;G;}' output/sensorTop_netlist.v
	sed -i "" '1{h;s/.*/\/\/ **Custom imports** /;G;}' output/sensorTop_netlist.v

# log circuit components count
	sleep 1
	$(eval dffsr=$(shell cat output/sensorTop_netlist.v |grep -w DFFSR|wc -l))
	$(eval dff=$(shell cat output/sensorTop_netlist.v |grep -w DFF|wc -l))
	$(eval nand=$(shell cat output/sensorTop_netlist.v|grep -w NAND|wc -l))
	$(eval and=$(shell cat output/sensorTop_netlist.v|grep -w AND|wc -l))
	$(eval nor=$(shell cat output/sensorTop_netlist.v|grep -w NOR|wc -l))
	$(eval or=$(shell cat output/sensorTop_netlist.v|grep -w OR|wc -l))
	$(eval datestring=$(shell date +%FT%T))
	sed -i "" '1{h;s/.*/'$(datestring)' dffsr: '$(dffsr)', dff: '$(dff)', and: '$(and)', nand: '$(nand)', or: '$(or)', nor: '$(nor)'/;G;}' output/component_count.log

all:
	${MAKE} sv2v PW=${PW} PH=${PH};
	${MAKE} synth;
	${MAKE} svg;