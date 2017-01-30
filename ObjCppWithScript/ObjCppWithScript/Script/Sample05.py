'''
Python (Sample05.py)
'''
from PyExt import DbgString, Sum

DbgString("Sample05.py")
nStart = 1
nStop = 10
nSum = Sum(1, 10)
DbgString("Sum(%d, %d) : %d\n" % (nStart, nStop, nSum)) 