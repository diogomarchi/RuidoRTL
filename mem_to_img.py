'''
Este programa converte um arquivo .mem
para uma imagem 64x64
'''
import cv2 as cv
import os 
import numpy as np
from matplotlib import pyplot as plt

# arquitetura da memoria
WIDTH=8
DEPTH=65536

# imagem resultante
img = np.ndarray((256, 256), np.float32)

with open("resultado.mem", "r") as mem:
    
    # leitura de cabecalho
    print(mem.readline())
    print(mem.readline())
    print(mem.readline())
    
    for i in range(256):
        for j in range(256):
            line = mem.readline().replace("\n", "")            
            val = line.split(": ")[1]
            int_val = int(val,2)
            img[i, j] = int_val / 255       
            print(int_val)
            
    plt.imshow(img, 'gray')
    plt.show()
    cv.imwrite("resultado.png", img*255)
    
    
    