import numpy as np
from PIL import Image
import os.path
# import matplotlib.pyplot as plt

script_dir = os.path.dirname(os.path.abspath(__file__))
img = Image.open(os.path.join(script_dir, 'finch_128x128.png')).convert('L')
arr = np.array(img)

# print(arr.shape)

# print(len(arr))



f = open(os.path.join(script_dir, 'scene.txt'), "w")
# verilogStr = ""

# verilogStr += "'{\n"
# for idx, line in enumerate(arr):
#     verilogStr += "'{"
#     for i, el in enumerate(line):
#         # verilogStr += "8'b" + "{0:08b}".format(el)
#         verilogStr += str(el)
#         if i != len(line)-1:
#             verilogStr += ','
#     verilogStr += "}"
#     if idx != len(arr)-1:
#         verilogStr += ',\n'
# verilogStr += "\n}"
        

# f.write(verilogStr)

# print(arr)

for line in arr:
    for el in line:
        f.write(str(el) + '\n')

f.close()