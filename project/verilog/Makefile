
# -Wall gjør at flere detaljer blir printet til konsollen
ps:
	iverilog -g2012 -Wall -o modules/pixel_sensor/pixelSensor.out modules/pixel_sensor/pixelSensor_tb.v
	vvp -n pixelSensor.out

# pixel array
pa:
	iverilog -g2012 -Wall -o modules/pixel_array/pixelArray.out modules/pixel_array/pixelArray_tb.v
	vvp -n pixelArray.out

# pixel row
pr:
	iverilog -g2012 -Wall -o modules/pixel_row/pixelRow.out modules/pixel_row/pixelRow_tb.v
	vvp -n pixelRow.out