'''
Python (Sample03.py)
'''

szWelcomMessage = "Hello World"
szWhoamI = "Sample03.py"

def myfunc_1 ():
	global szWhoamI
	szWhoamI = "myfunc_1"
	return

def myfunc_2 ():
	global szWhoamI
	szWhoamI = "myfunc_2"
	return "Success";


def myfunc_3 ():
	global szWhoamI
	szWhoamI = "myfunc_3"
	return "Success", False;


def myfunc_4 (szMyName):
	global szWhoamI
	szWhoamI = szMyName
	return "Success", True;


def myfunc_5 (szMyName, bReturnValue):
	global szWhoamI
	szWhoamI = szMyName
	return "Success", bReturnValue;