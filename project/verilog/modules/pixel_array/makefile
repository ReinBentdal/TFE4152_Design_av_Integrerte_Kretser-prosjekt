# pixel array
sim:
	iverilog -g2012 -Wall -o pixelArray.out pixelArray_tb.sv
	vvp -n pixelArray.out

sv2v:
	sv2v --define=synthesize --write=output/pixelArray.v pixelArray.sv
	find . -name 'pixelArray.v' -print0 | xargs -0 sed -i "" "s/PixelSensorConfig_//g"

synth:
	yosys pixelArray.ys

# include nesecary library in netlist file
	sed -i "" '1{h;s/.*//;G;}' output/pixelArray_netlist.v
	sed -i "" '1{h;s/.*/`include "..\/..\/..\/components\/gates.lib"/;G;}' output/pixelArray_netlist.v
	sed -i "" '1{h;s/.*/\/\/ **Custom imports** /;G;}' output/pixelArray_netlist.v


svg:
	rm output/pixelArray_diagram.svg
	netlistsvg output/pixelArray.json -o output/pixelArray_diagram.svg
