
# -Wall gjør at flere detaljer blir printet til konsollen
ps:
	iverilog -g2012 -Wall -o pixelSensor.out pixelSensor_tb.v
	vvp -n pixelSensor.out

# pixel array
pa:
	iverilog -g2012 -Wall -o pixelArray.out pixelArray_tb.v
	vvp -n pixelArray.out

# pixel row
pr:
	iverilog -g2012 -Wall -o pixelRow.out pixelRow_tb.v
	vvp -n pixelRow.out