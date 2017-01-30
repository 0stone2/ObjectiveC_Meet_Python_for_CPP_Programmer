'''
Python (Sample07.py)
'''
from PyExt import DbgString, SumAndAverage

DbgString("Sample07.py")
nStart = 1
nStop = 10
nSum, nAverage = SumAndAverage(1, 10)
DbgString("SumAndAverage(%d, %d) : 합 = %d,  평균 = %d\n" % (nStart, nStop, nSum, nAverage)) 