#!/usr/local/bin/python

import pygame
import random

class Screen:

    def __init__(self, height, length):
        self.size = [length, height]
        self.active = False

    def start(self):
        pygame.init()

        self.screen = pygame.display.set_mode(self.size)

        pygame.display.set_caption("Simulated screen")

        self.clock = pygame.time.Clock()

    def clean(self):
        self.screen.fill([0,0,0]) #fill with black

    def set_pixel(self,pos,color):
        self.screen.set_at(pos,color)


    def update(self):
        #Check for inputs
        for event in pygame.event.get():  # User did something
            if event.type == pygame.QUIT:  # If user clicked close
                self.active = True  # Flag that we are done so we exit this loop
                pygame.quit()
        pygame.display.flip()

    def is_active(self):
        return self.active
