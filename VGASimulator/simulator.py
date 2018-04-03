#!/usr/local/bin/python

from screen import Screen
from vga_controller import VGAController
from reader import Reader
from translator import Translator
from time import sleep
import config


def clean():
    reader.clean()
    vga_controller.save()

def loop():
    info = reader.readline()
    while (info):

        values = info.split(config.DELIMITER)
        if (len(values) < 5):
            print "Values not matching, expecting x y r g b"
            info = reader.readline()
            continue
        vga_controller.update(int(values[0]),
                              int(values[1]),
                              translator.bin_to_int(values[2]),
                              translator.bin_to_int(values[3]),
                              translator.bin_to_int(values[4]))
        info = reader.readline()

# #Start a screen
# screen = Screen(config.VISIBLE_HEIGHT,config.VISIBLE_WIDTH)
# screen.start()

# Start the vgaController
vga_controller = VGAController([config.VISIBLE_WIDTH, config.VISIBLE_HEIGHT])

# Start a reader
reader = Reader()
reader.initialize()

# Start translator
translator = Translator()

print "Starting"
try:
    loop()
except Exception as e:
    print e
clean()
