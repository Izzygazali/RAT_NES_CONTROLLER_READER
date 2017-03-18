import serial
import binascii

from pykeyboard import PyKeyboard

k = PyKeyboard()

ser = serial.Serial('/dev/ttyUSB1', 9600) # The port may need to be changed for different systems
ser.close()
ser.open()

UP = 1
LEFT = 2
DOWN = 4
RIGHT = 8
START = 16
SELECT = 32
A = 64
B = 128

last_byte = 255

while True:
	in_byte = ord(ser.read(1))	
	print in_byte

        # UP
        UP_bit = in_byte & UP
        if (UP_bit == 1 and not(last_byte == in_byte)):
		k.press_key('W')
	elif (not(last_byte == in_byte)):
 		k.release_key('W') 

	# LEFT
        LEFT_bit = in_byte & LEFT
        if (LEFT_bit == 2 and not(last_byte == in_byte)):
		k.press_key('A')
        elif (not(last_byte == in_byte)):
 		k.release_key('A')
 
	# DOWN
        DOWN_bit = in_byte & DOWN
        if (DOWN_bit == 4 and not(last_byte == in_byte)):
		k.press_key('S')
	elif (not(last_byte == in_byte)):
 		k.release_key('S') 

        # RIGHT
        RIGHT_bit = in_byte & RIGHT
        if (RIGHT_bit == 8 and not(last_byte == in_byte)):
		k.press_key('D')
	elif (not(last_byte == in_byte)):
 		k.release_key('D') 

	# START
        START_bit = in_byte & START
        if (START_bit == 16 and not(last_byte == in_byte)):
		k.press_key('N')
	elif (not(last_byte == in_byte)):
 		k.release_key('N') 

	# SELECT
        SELECT_bit = in_byte & SELECT
        if (SELECT_bit == 32 and not(last_byte == in_byte)):
		k.press_key('M')
	elif (not(last_byte == in_byte)):
 		k.release_key('M')
 
	# A
        A_bit = in_byte & A
        if (A_bit == 64 and not(last_byte == in_byte)):
		k.press_key('L')
	elif (not(last_byte == in_byte)):
 		k.release_key('L') 

        # B
        B_bit = in_byte & B
        if (B_bit == 128 and not(last_byte == in_byte)):
		k.press_key('K')
	elif (not(last_byte == in_byte)):
 		k.release_key('K') 

        last_byte = in_byte


       
