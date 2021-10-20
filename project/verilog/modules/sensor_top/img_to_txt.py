import numpy as np
from PIL import Image
import os.path
import matplotlib.pyplot as plt

script_dir = os.path.dirname(os.path.abspath(__file__))
img = Image.open(os.path.join(script_dir, 'finch.png')).convert('L')
arr = np.array(img)

f = open(os.path.join(script_dir, 'scene.txt'), "w")

print(arr)

for line in arr:
    for el in line:
        f.write(str(el) + '\n')

f.close()