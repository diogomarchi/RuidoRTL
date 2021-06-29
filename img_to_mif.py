'''
Este programa converte uma imagem 64x64 
em RGB para um arquivo .mif
'''
import cv2 as cv
import os 
import numpy as np

LARGURA_IMG = 256
ALTURA_IMG = 256

# definicoes arquitetura memoria
WIDTH = 8
DEPTH = ALTURA_IMG*LARGURA_IMG

def cabecalho ():
    str_ret = ""
    str_ret += "-- begin_signature\n"
    str_ret += "-- ROM\n"
    str_ret += "-- end_signature\n"
    str_ret += "WIDTH="+str(WIDTH)+";\n"
    str_ret += "DEPTH="+str(DEPTH)+";\n"
    str_ret += "ADDRESS_RADIX=UNS;\n"
    str_ret += "DATA_RADIX=BIN;\n\n"
    str_ret += "CONTENT BEGIN\n"
    print(str_ret)
    return str_ret
    

def rodape():
    str_ret = ""
    str_ret += "\nEND;\n"
    print(str_ret)
    return str_ret


# inicio     
im = cv.imread("lena_cinza.png")
im = cv.resize(im, (ALTURA_IMG,LARGURA_IMG))
gray = cv.cvtColor(im, cv.COLOR_BGR2GRAY)
cv.imwrite("entrada.png", im)

index = 0
with open("image.mif", "w") as mif:
    mif.writelines(cabecalho())
    for linha in gray:
        for pixel in linha:
            bin_value = bin(pixel).replace("0b", "")
            bin_value = bin_value.zfill(WIDTH)           
            mif.writelines(
                    str(DEPTH-index-1) +
                    ": " + bin_value +
                    "; \n")
            print(DEPTH-index-1,
                    ": ", bin_value)
            index += 1
    
    mif.writelines(rodape())