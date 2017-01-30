//
//  PyExt.h
//  PyExt
//
//  Created by 박 창진 on 2017. 1. 14..
//  Copyright © 2017년 박 창진. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Python/Python.h>

@interface PyExt : NSObject

@end


PyMODINIT_FUNC PyInit_PyExt(void);
static PyObject *DbgString(PyObject *pSelf, PyObject *pArg);
static PyObject *SumAndAverage(PyObject *pSelf, PyObject *pArg);
