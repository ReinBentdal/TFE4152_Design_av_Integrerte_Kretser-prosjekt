import numpy as np
import matplotlib.pyplot as plt
import os.path

HEIGHT = 128
WIDTH = 128

script_dir = os.path.dirname(os.path.abspath(__file__))

arr = np.loadtxt(os.path.join(script_dir, 'image.txt'), dtype=int)

arrReshape = np.reshape(arr, (HEIGHT, WIDTH))

plt.imshow(arrReshape, cmap='Greys', interpolation='none')
plt.axis('off')
# plt.savefig(os.path.join(script_dir, 'hello_world.png'), bbox_inches='tight')
plt.show()
