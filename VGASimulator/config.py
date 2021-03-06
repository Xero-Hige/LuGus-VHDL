
SCREEN_REFRESH_FREQUENCY = 60 #60 Hz

SYNC_VALUE = 0 #The value that h y v sync have when the screen is visible

VISIBLE_WIDTH = 350
HORIZONTAL_BACK_PORCH = 48
HORIZONTAL_FRONT_PORCH = 16
HORIZONTAL_SYNC = 96
TOTAL_HORIZONTAL_PIXELS = VISIBLE_WIDTH + HORIZONTAL_BACK_PORCH + HORIZONTAL_FRONT_PORCH + HORIZONTAL_SYNC

VISIBLE_HEIGHT = 350
VERTICAL_BACK_PORCH = 33
VERTICAL_FRONT_PORCH = 10
VERTICAL_SYNC = 2
TOTAL_VERTICAL_PIXELS = VISIBLE_HEIGHT + VERTICAL_BACK_PORCH + VERTICAL_FRONT_PORCH + VERTICAL_SYNC

PIXEL_TIME = (1.0/(SCREEN_REFRESH_FREQUENCY*(TOTAL_VERTICAL_PIXELS*TOTAL_HORIZONTAL_PIXELS)))*1E+9 # Time in ns

PIXELS_FILE_NAME = "pixels.txt"
DELIMITER = " "