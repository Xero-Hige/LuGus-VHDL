#!/usr/local/bin/python
import config

class VGAController:

    def __init__(self,screen):
        self.screen = screen
        self.last_y = 0


    #delta_t should be in ns
    def update(self,x,y,red,green,blue):
        if(x == 0 and y == 0):
            print "Cleaning"
            self.screen.clean()
            self.screen.update()
        print "Printing: " + str([x,y])
        self.screen.set_pixel([x,y],[red,green,blue])
        if(y > self.last_y + 10):
            self.screen.update()
            self.last_y = y




