# -*- coding: utf-8 -*-
"""
Created on Tue Mar 27 20:38:43 2018

@author: Stefan
"""
from __future__ import print_function, division

import matplotlib.pyplot as plt
import scipy.signal  as sig
import struct
import sounddevice as sd
import soundfile as sf


import numpy as np
from scipy.fftpack import fft
from scipy import signal
from tkinter import*

root = Tk()
root.geometry('500x500')
w1 = Scale(root, from_=10, to=-10)
w2 = Scale(root, from_=10, to=-10)
w3 = Scale(root, from_=10, to=-10)
w4 = Scale(root, from_=10, to=-10)
w5 = Scale(root, from_=10, to=-10)

label1 = Label(root, text = "Band1")

label2 = Label(root, text = "Band2")

label3 = Label(root, text = "Band3")


label4 = Label(root, text = "Band4")

label5 = Label(root, text = "Band5")

dB = Label(root, text = "dB")


label1.grid(row=0, column=1,sticky=E)
w1.grid(row = 1 , column = 1, sticky = E)
label2.grid(row=0,column=2,sticky=E)
w2.grid(row = 1 , column = 2, sticky = E)
label3.grid(row=0,column=3,sticky=E)
w3.grid(row = 1, column = 3, sticky = E)
label4.grid(row=0,column=4,sticky=E)
w4.grid(row = 1 , column = 4, sticky = E)
label5.grid(row=0,column=5,sticky=E)
w5.grid(row = 1 , column =5, sticky = E)

dB.grid(row=1,pady = 50)


def Butterworth(event):
    filename = 'LC_Arpegg_128_C_3.wav'
    data,fs = sf.read(filename, dtype='float32')
    t = np.arange(0,7.5,7.5/330750)
    b,a = signal.butter(4, 500/(fs/2), 'low')
    print(b)

button_1=Button(root,text="Whats b")
button_1.bind("<Button-1>",Butterworth)

    

root.mainloop()