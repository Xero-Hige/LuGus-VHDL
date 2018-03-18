#!/usr/local/bin/python

from screen import Screen
from vga_controller import VGAController
from reader import Reader
from translator import Translator
from time import sleep
import config

def loop():
    info = reader.readline()
    while (info):

        values = info.split(config.DELIMITER)
        if (len(values) < 5):
            print "Values not matching, expecting x y r g b"
            break
        try:
            vga_controller.update(int(values[0]),
                                  int(values[1]),
                                  translator.bin_to_int(values[2]),
                                  translator.bin_to_int(values[3]),
                                  translator.bin_to_int(values[4]))
        except IndexError:
            break
        info = reader.readline()

    screen.clean()
    reader.clean()


#Start a screen
screen = Screen(config.VISIBLE_HEIGHT,config.VISIBLE_WIDTH)
screen.start()

#Start the vgaController
vga_controller = VGAController(screen)

#Start a reader
reader = Reader()
reader.initialize()

#Start translator
translator = Translator()

print "Starting"

loop()

