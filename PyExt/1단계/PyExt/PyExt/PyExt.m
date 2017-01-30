//
//  PyExt.m
//  PyExt
//
//  Created by 박 창진 on 2017. 1. 14..
//  Copyright © 2017년 박 창진. All rights reserved.
//

#import "PyExt.h"

@implementation PyExt

@end

static PyObject *DbgString(PyObject *pSelf, PyObject *pArg)
{
    PyObject *	pReturn = NULL;
    char *		szDbgString;
    wchar_t		wszDbgString[512];
    
    /* Treat arg as a borrowed reference. */
    Py_INCREF(pArg);
    
    PyArg_Parse(pArg, "s", &szDbgString);
    
    NSLog(@"%s", szDbgString);
    
    Py_INCREF(Py_None);
    pReturn = Py_None;
    
    return pReturn;
}

static PyObject *SumAndAverage(PyObject *pSelf, PyObject *pArg)
{
    PyObject *	pReturn = NULL;
    int			nStartVar = 0;
    int			nStopVar = 0;
    int			nSum = 0;
    int			nAverage = 0;
    
    /* Treat arg as a borrowed reference. */
    Py_INCREF(pArg);
    
    PyArg_ParseTuple(pArg, "II", &nStartVar, &nStopVar);
    
    for (int nIndex = nStartVar; nIndex <= nStopVar; nIndex++)
    {
        nSum += nIndex;
    }
    
    nAverage = nSum / (nStopVar - nStartVar + 1);
    
    pReturn = Py_BuildValue("(ll)", nSum, nAverage);
    
    return pReturn;
}

static PyMethodDef ExtMethods[] = {
    { "DbgString",  (PyCFunction)DbgString, METH_O, "Execute a OutputDebugString" },
    { "SumAndAverage",  (PyCFunction)SumAndAverage, METH_VARARGS, "Execute a OutputDebugString" },
    { NULL, NULL, 0, NULL }
};


static struct PyModuleDef PyExt_Module = {
    PyModuleDef_HEAD_INIT,
    "PyExt",
    NULL,
    -1,
    ExtMethods
};

PyMODINIT_FUNC InitPyExt(void)
{
    return PyModule_Create(&PyExt_Module);
}




