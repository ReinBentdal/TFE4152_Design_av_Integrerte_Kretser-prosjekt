# Creates data from a scene which SystemVerilog can read

import numpy as np
from PIL import Image
import os.path
import pyperclip

# LOAD SCENE TO NUMPU ARRAY
script_dir = os.path.dirname(os.path.abspath(__file__))
img = Image.open(os.path.join(script_dir, 'finch_24x24.png')).convert('L')
arr = np.array(img)

# GENERATE PACHED 1D ARRAY FROM SCENE
def array1d(arr):
    verstr = ""

    for idx, line in enumerate(arr):
        row = ""
        for i, el in enumerate(line):
            bitarray = [int(digit) for digit in bin(el)[2:]]
            while (len(bitarray) < 8):
                bitarray.insert(0, 0)
            # bitarray.reverse()
            px = ""
            for b in bitarray:
                px = px + f'{b}'
            row = px + row
        verstr = row + verstr

    verstr = f'{(8*24*24)}' + "'b" + verstr
    verstr += ";"

    return verstr
    # f.write(verstr)

# GENERATE 2D ARRAY FROM SCENE
def array2d(arr):
    verilogStr = ""

    verilogStr += "{\n"
    for idx, line in enumerate(arr):
        # verilogStr += "'{"
        for i, el in enumerate(line):
            verilogStr += "8'b" + "{0:08b}".format(el)
            # verilogStr += str(el)
            # if i != len(line)-1:
            verilogStr += '\n'
        # verilogStr += "}"
        # if idx != len(arr)-1:
            # verilogStr += ',\n'
    verilogStr += "}"
    return verilogStr
    # f.write(verilogStr)

# GENERATE FILE WITH PIXEL VALUES WHICH VERILOG CAN READ
def fileReadable(arr):
    data = ""
    for line in arr:
        for el in line:
            data += str(el) + '\n'
    return data

pyperclip.copy(array1d(arr))
print("ARRAY COPIED TO CLIPBOARD")

# pyperclip.copy(array2d(arr))
# print("ARRAY COPIED TO CLIPBOARD")

# f = open(os.path.join(script_dir, 'scene.txt'), "w")

# f.write(fileReadable(arr))

# f.close()