'''
Python (Sample08.py)
'''
from PyExt import DbgString, SumAndAverage

DbgString("Sample08.py")
nStart = 1
nStop = 10
nSum, nAverage = SumAndAverage(1, 10)
DbgString("SumAndAverage(%d, %d) : Sum = %d,  Average = %d\n" % (nStart, nStop, nSum, nAverage)) 
