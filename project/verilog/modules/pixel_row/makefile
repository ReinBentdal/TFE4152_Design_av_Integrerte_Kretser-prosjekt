# pixel row
sim:
	iverilog -g2012 -Wall -o pixelRow.out pixelRow_tb.sv
	vvp -n pixelRow.out

sv2v:
	sv2v --define=synthesize --write=output/pixelRow.v pixelRow.sv

synth:
	yosys pixelRow.ys

# include nesecary library in netlist file
ifeq ($(shell uname), Darwin)
	sed -i "" '1{h;s/.*//;G;}' output/pixelRow_netlist.v
	sed -i "" '1{h;s/.*/`include "..\/..\/..\/components\/gates.lib"/;G;}' output/pixelRow_netlist.v
	sed -i "" '1{h;s/.*/\/\/ **Custom imports** /;G;}' output/pixelRow_netlist.v
else
	sed -i '1{h;s/.*//;G;}' output/pixelRow_netlist.v
	sed -i '1{h;s/.*/`include "..\/..\/..\/components\/gates.lib"/;G;}' output/pixelRow_netlist.v
	sed -i '1{h;s/.*/\/\/ **Custom imports** /;G;}' output/pixelRow_netlist.v
endif

svg:
	rm output/pixelRow_diagram.svg
	netlistsvg output/pixelRow.json -o output/pixelRow_diagram.svg

