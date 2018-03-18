#!/usr/local/bin/python

import os
import config

class Reader:

    #Creates a fifo to read from
    def initialize(self):
        try:
            os.mkfifo(config.FIFO_NAME)
        except OSError:
            os.remove(config.FIFO_NAME)
            self.initialize()
        self.input = open(config.FIFO_NAME,'r')

    def readline(self):
        return self.input.readline()

    def clean(self):
        self.input.close()
        os.remove(config.FIFO_NAME)
