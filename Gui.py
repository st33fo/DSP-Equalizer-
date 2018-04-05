# -*- coding: utf-8 -*-
"""
Created on Tue Mar 27 16:32:17 2018

@author: Stefan
"""

from tkinter import *

root = Tk()
"""
Creating a label to place text on
"""

# =============================================================================
# theLabel = Label(root, text = "This is too easy")
# theLabel.pack()
# =============================================================================
topFrame = Frame(root)
topFrame.pack()
bottomFrame = Frame(root)
bottomFrame.pack(side=BOTTOM)

button1 = Button(topFrame, text = "Filter", fg = "red")
button2 = Button(topFrame, text = "Filter2", fg = "blue")
button3 = Button(topFrame, text = "Filter3", fg = "green")
button4 = Button(bottomFrame, text = "Filter4", fg = "purple")

button1.pack(side=LEFT),button2.pack(side=LEFT),button3.pack(side=LEFT),button4.pack(side=BOTTOM)



root.mainloop() 