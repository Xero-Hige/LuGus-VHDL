#!/usr/local/bin/python
from PIL import Image

class VGAController:

    def __init__(self,size):
        self.size = size
        self.images = []
        self.image = Image.new( 'RGB', (size[0],size[1]), "black")
        self.pixels = self.image.load()


    #delta_t should be in ns
    def update(self,x,y,red,green,blue):
        if(x == 0 and y == 0):
            print "Cleaning and saving frame"
            self.images.append(self.image.copy())
        self.pixels[x,y] = (red,green,blue)

    def save(self):
        self.images.append(self.image.copy())
        self.image.save("rotation.gif", save_all=True, append_images=self.images)




