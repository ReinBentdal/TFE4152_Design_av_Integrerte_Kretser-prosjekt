*Project uses [Dicex](https://github.com/wulffern/dicex). View Disex README for instructions on running repository.*

# Running project
## Required software
In addition to the software provided by Dicex/Ciceda, these programs has to be installed for certain commands to work
* [NetlistSVG](https://github.com/nturley/netlistsvg) for creating circuit diagrams

## Digital
Navigate to project/verilog. To run top module, navigate further to modules/sensor_top/, view makefile for all used commands. 
Simulate 24x24 pixel array:
``` sh
make sim PW=24 PH=24
```

Synthesize and simulate netlist
```sh
make synthsim PW=24 PH=24
```

Plot simulation result
``` sh
make plot PW=24 PH=24
```

Create circuit diagram
``` sh
make svg
```

Change parameters in project/verilog/pixel_sensor_config.sv. Make sure, if array size is changed, that the correct scene is used in project/verilog/modules/pixel_sensor/pixelSensorAnalog.sv

## Analog
