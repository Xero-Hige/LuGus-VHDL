#!/usr/local/bin/python

import config

class Reader:

    #Creates a fifo to read from
    def initialize(self):
        self.input = open(config.PIXELS_FILE_NAME, 'r')

    def readline(self):
        return self.input.readline()

    def clean(self):
        self.input.close()
