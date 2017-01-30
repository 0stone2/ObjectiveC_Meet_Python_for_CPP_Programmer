//
//  ViewController.m
//  ObjCppWithScript
//
//  Created by 박 창진 on 2017. 1. 14..
//  Copyright © 2017년 박 창진. All rights reserved.
//

#import "ViewController.h"
#import <Python/Python.h>
#import <dlfcn.h>

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.
    NSString *Script = @"Python";

    [_Box_1 setTitle: [NSString stringWithFormat:@"1장 - Objective C에서 %@ 호출하기", Script]];
    [_Button_1 setTitle: [NSString stringWithFormat:@"예제 1 - %@ 스크립트\n 파일 실행하기", Script]];
    [_Button_2 setTitle: [NSString stringWithFormat:@"예제 2 - %@ 전역변수\n 조작하기", Script]];
    [_Button_3 setTitle: [NSString stringWithFormat:@"예제 3 - %@ 함수\n 호출하기", Script]];
    
    [_Box_2 setTitle: [NSString stringWithFormat:@"2장 - %@에서 Objective C 호출하기", Script]];
    [_Button_4 setTitle: [NSString stringWithFormat:@"예제 4 - %@에서 호출\n 가능한 Objective C 함수\n 만들기", Script]];
    [_Button_5 setTitle: [NSString stringWithFormat:@"예제 5 - %@에서 호출\n 가능한 Objective C 함수\n 만들기", Script]];
    [_Button_6 setTitle: [NSString stringWithFormat:@"예제 6 - %@에서 호출\n 가능한 Objective C 함수\n 만들기", Script]];
    
    [_Box_3 setTitle: [NSString stringWithFormat:@"3장 - %@ 확장 모듈 만들기", Script]];
    [_Button_7 setTitle: [NSString stringWithFormat:@"예제 7 - MyDbgString 함수를\n 동적 라이브러리로 구현하기"]];
    [_Button_8 setTitle: [NSString stringWithFormat:@"예제 8 - 동적 라이브러리를 %@에서\n 직접 호출할수 있도록 만들기", Script]];
    
}


- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}

- (IBAction)Button_Exit_Click:(id)sender {
    [NSApp terminate:self];
}


void Append_Script_Path()
{
    NSFileManager *pFileManager;
    NSString *pCurrentDir;
    //char szScriptPath[512];
    int nSuccess = 0;
    
    pFileManager= [[NSFileManager alloc] init];
    pCurrentDir = [pFileManager currentDirectoryPath];
    
    /*
     sprintf(szScriptPath, "sys.path.append(\"%s/Script\")", [pCurrentDir UTF8String]);
     nSuccess = PyRun_SimpleString("import sys");
     nSuccess = PyRun_SimpleString(szScriptPath);
    */
    /*
     sprintf(szScriptPath, "sys.path.append(\"%s/Script\")", [pCurrentDir UTF8String]);
     nSuccess = PyRun_SimpleString("import sys");
     nSuccess = PyRun_SimpleString(szScriptPath);
     
     
     PyObject *sys_path = PySys_GetObject("path");
     
     char *szReturnString;
     if (TRUE == PyList_Check(sys_path))
     {
     for (int nIndex = 0; nIndex < PyList_Size(sys_path); nIndex++)
     {
     PyObject *Item = PyList_GetItem(sys_path, nIndex);
     PyArg_Parse(Item, "s", &szReturnString);
     
     NSLog(@"[%d]%s\n", nIndex, szReturnString);
     }
     }
     */
    

    NSString *pScriptPath =  [NSString stringWithFormat:@"%@/Script", SCRIPT_DIR];

    
    wchar_t szScriptPath[512];
    
    const char *szUTF8String;
    szUTF8String =[pScriptPath UTF8String];
    
    mbstowcs(szScriptPath, szUTF8String, 512);

    PySys_SetPath(szScriptPath);
}

- (IBAction)Button_1_Click:(id)sender {
    bool bSuccess = false;
    
    PyObject *pModule = NULL;
    
    NSLog(@"Enter %@", NSStringFromSelector(_cmd));
    
    @try {
        Py_Initialize();
        Append_Script_Path();
        
        pModule = PyImport_ImportModule("Sample01");
        if (NULL == pModule) {
            [NSException raise:@"PyImport_ImportModule" format:@"PyImport_ImportModule = %d", (int)pModule];
        }
        
        
        bSuccess = true;
    }
    @catch (NSException *exception)  {
        NSLog( @"NSException caught" );
        NSLog( @"Name: %@", exception.name);
        NSLog( @"Reason: %@", exception.reason );
    }
    @finally {
        
        if (NULL!= pModule) Py_DecRef(pModule);
        Py_Finalize();
    }
    
    NSLog(@"Leave %@", NSStringFromSelector(_cmd));
}

- (IBAction)Button_2_Click:(id)sender {
    bool bSuccess = false;
    PyObject *pModule = NULL;
    
    PyObject *	pWelcomMessage = NULL;
    PyObject *	pWhoamI = NULL;
    PyObject *	pVersion = NULL;
    PyObject *	pNewVersion = NULL;
    
    char *		szWelcomMessage = NULL;
    char *		szWhoamI = NULL;
    long		nVersion = 0;
    
    NSLog(@"Enter %@", NSStringFromSelector(_cmd));
    
    @try {
        Py_Initialize();
        Append_Script_Path();
        pModule = PyImport_ImportModule("Sample02");
        if (NULL == pModule) {
            [NSException raise:@"PyImport_ImportModule" format:@"PyImport_ImportModule = %d", (int)pModule];
        }
        
        
        pWelcomMessage = PyObject_GetAttrString(pModule, "szWelcomMessage");
        pWhoamI = PyObject_GetAttrString(pModule, "szWhoamI");
        pVersion = PyObject_GetAttrString(pModule, "nVersion");
        
        
        PyArg_Parse(pWelcomMessage, "s", &szWelcomMessage);
        PyArg_Parse(pWhoamI, "s", &szWhoamI);
        PyArg_Parse(pVersion, "l", &nVersion);
        
        NSLog(@"szWelcomMessage = %s\n", szWelcomMessage);
        NSLog(@"szWhoamI = %s\n", szWhoamI);
        NSLog(@"nVersion = %d\n", (int)nVersion);
        
        
        pNewVersion = Py_BuildValue("l", 3);
        PyObject_SetAttrString(pModule, "nVersion", pNewVersion);
        
        pVersion = PyObject_GetAttrString(pModule, "nVersion");
        PyArg_Parse(pVersion, "l", &nVersion);
        NSLog(@"New nVersion = %d\n", (int)nVersion);
        
        bSuccess = true;
    }
    @catch (NSException *exception)  {
        NSLog( @"NSException caught" );
        NSLog( @"Name: %@", exception.name);
        NSLog( @"Reason: %@", exception.reason );
    }
    @finally {
        
        if (NULL!= pModule) Py_DECREF(pModule);
        
        if (NULL != pModule) Py_DECREF(pModule);
        if (NULL != pWelcomMessage) Py_DECREF(pWelcomMessage);
        if (NULL != pWhoamI) Py_DECREF(pWhoamI);
        if (NULL != pVersion) Py_DECREF(pVersion);
        
        if (NULL != pNewVersion) Py_DECREF(pNewVersion);
        
        Py_Finalize();
    }
    
    NSLog(@"Leave %@", NSStringFromSelector(_cmd));
}

- (IBAction)Button_3_Click:(id)sender {
    bool bSuccess = false;
    
    PyObject *pModule = NULL;
    
    PyObject *	pWelcomMessage = NULL;
    PyObject *	pWhoamI = NULL;
    
    
    PyObject *	pFunction_01 = NULL;
    PyObject *	pFunction_02 = NULL;
    PyObject *	pFunction_03 = NULL;
    PyObject *	pFunction_04 = NULL;
    PyObject *	pFunction_05 = NULL;
    PyObject *  pArgument = NULL;
    
    PyObject *	pReturn = NULL;
    char *		szWelcomMessage = NULL;
    char *		szWhoamI = NULL;
    char *		szReturnString = NULL;
    PyObject *	pBoolean = NULL;
    BOOL        bBoolean = FALSE;
    int         nBoolean = 0;
    
    NSLog(@"Enter %@", NSStringFromSelector(_cmd));
    
    @try {
        Py_Initialize();
        Append_Script_Path();
        
        pModule = PyImport_ImportModule("Sample03");
        if (NULL == pModule) {
            [NSException raise:@"PyImport_ImportModule" format:@"PyImport_ImportModule = %d", (int)pModule];
        }
        
        
        
        pWelcomMessage = PyObject_GetAttrString(pModule, "szWelcomMessage");
        pWhoamI = PyObject_GetAttrString(pModule, "szWhoamI");
        
        PyArg_Parse(pWelcomMessage, "s", &szWelcomMessage);
        PyArg_Parse(pWhoamI, "s", &szWhoamI);
        
        NSLog(@"szWelcomMessage = %s\n", szWelcomMessage);
        NSLog(@"szWhoamI = %s\n", szWhoamI);
        
        
        //////////////////////////////////////////////////////////////
        //
        // Call myfunc_1
        //
        
        NSLog(@"[myfunc_1]========================================");
        pFunction_01 = PyObject_GetAttrString(pModule, "myfunc_1");
        if (NULL == pFunction_01)
            [NSException raise:@"PyObject_GetAttrString" format:@"PyObject_GetAttrString = %s", "myfunc_1"];
        
        pReturn = PyObject_CallObject(pFunction_01, NULL);
        if (NULL == pReturn)
            [NSException raise:@"PyObject_CallObject" format:@"PyObject_CallObject = %s", "myfunc_1"];
        
        
        pWelcomMessage = PyObject_GetAttrString(pModule, "szWelcomMessage");
        pWhoamI = PyObject_GetAttrString(pModule, "szWhoamI");
        
        PyArg_Parse(pWelcomMessage, "s", &szWelcomMessage);
        PyArg_Parse(pWhoamI, "s", &szWhoamI);
        
        NSLog(@"[myfunc_1]szWelcomMessage = %s\n", szWelcomMessage);
        NSLog(@"[myfunc_1]szWhoamI = %s\n\n", szWhoamI);
        
        
        
        //////////////////////////////////////////////////////////////
        //
        // Call myfunc_2
        //
        NSLog(@"[myfunc_2]========================================");
        pFunction_02 = PyObject_GetAttrString(pModule, "myfunc_2");
        if (NULL == pFunction_02)
            [NSException raise:@"PyObject_GetAttrString" format:@"[%s]PyObject_GetAttrString = NULL", "myfunc_2"];
        
        pReturn = PyObject_CallObject(pFunction_02, NULL);
        if (NULL == pReturn)
            [NSException raise:@"PyObject_CallObject" format:@"[%s]PyObject_CallObject = NULL", "myfunc_2"];
        
        if (FALSE == PyUnicode_Check(pReturn))
            [NSException raise:@"PyObject_CallObject" format:@"[%s]pFunction_02 != String", "myfunc_2"];
        
        
        PyArg_Parse(pReturn, "s", &szReturnString);
        
        
        pWelcomMessage = PyObject_GetAttrString(pModule, "szWelcomMessage");
        pWhoamI = PyObject_GetAttrString(pModule, "szWhoamI");
        
        PyArg_Parse(pWelcomMessage, "s", &szWelcomMessage);
        PyArg_Parse(pWhoamI, "s", &szWhoamI);
        
        NSLog(@"[myfunc_2]Return = %s\n", szReturnString);
        NSLog(@"[myfunc_2]szWelcomMessage = %s\n", szWelcomMessage);
        NSLog(@"[myfunc_2]szWhoamI = %s\n\n", szWhoamI);
        
        
        
        
        /////////////////////////////////////////////////////////////
        //
        // Call myfunc_3
        //
        NSLog(@"[myfunc_3]========================================");
        pFunction_03 = PyObject_GetAttrString(pModule, "myfunc_3");
        if (NULL == pFunction_03)
            [NSException raise:@"PyObject_GetAttrString" format:@"[%s]PyObject_GetAttrString = NULL", "myfunc_3"];
        
        
        pReturn = PyObject_CallObject(pFunction_03, NULL);
        if (NULL == pReturn)
            [NSException raise:@"PyObject_CallObject" format:@"[%s]PyObject_CallObject = NULL", "myfunc_3"];
        if (FALSE == PyTuple_Check(pReturn))
            [NSException raise:@"PyObject_CallObject" format:@"[%s]pFunction_02 != Tuple", "myfunc_3"];
        
        PyArg_Parse(PyTuple_GetItem(pReturn, 0), "s", &szReturnString);
        
        pBoolean = PyTuple_GetItem(pReturn, 1);
        if (1 == PyObject_IsTrue(pBoolean)) bBoolean = TRUE;
        else bBoolean = FALSE;
        
        pWelcomMessage = PyObject_GetAttrString(pModule, "szWelcomMessage");
        pWhoamI = PyObject_GetAttrString(pModule, "szWhoamI");
        
        PyArg_Parse(pWelcomMessage, "s", &szWelcomMessage);
        PyArg_Parse(pWhoamI, "s", &szWhoamI);
        
        NSLog(@"[myfunc_3]Return 1 = %s\n", szReturnString);
        NSLog(@"[myfunc_3]Return 2 = %s\n", (TRUE == bBoolean)? "TRUE" : "FALSE" );
        NSLog(@"[myfunc_3]szWelcomMessage = %s\n", szWelcomMessage);
        NSLog(@"[myfunc_3]szWhoamI = %s\n\n", szWhoamI);
        
        
        
        /////////////////////////////////////////////////////////////
        //
        // Call myfunc_4
        //
        NSLog(@"[myfunc_4]========================================");
        pFunction_04 = PyObject_GetAttrString(pModule, "myfunc_4");
        if (NULL == pFunction_04)
            [NSException raise:@"PyObject_GetAttrString" format:@"[%s]PyObject_GetAttrString = NULL", "myfunc_4"];
        pArgument = PyTuple_Pack(1, PyUnicode_FromFormat("%s", "myfunc_4"));
        pReturn = PyObject_CallObject(pFunction_04, pArgument);
        if (NULL != pArgument) Py_DECREF(pArgument);
        pArgument = NULL;
        
        if (NULL == pReturn)
            [NSException raise:@"PyObject_CallObject" format:@"[%s]PyObject_CallObject = NULL", "myfunc_4"];
        if (FALSE == PyTuple_Check(pReturn))
            [NSException raise:@"PyObject_CallObject" format:@"[%s]pFunction_02 != Tuple", "myfunc_4"];
        
        
        PyArg_Parse(PyTuple_GetItem(pReturn, 0), "s", &szReturnString);
        pBoolean = PyTuple_GetItem(pReturn, 1);
        if (1 == PyObject_IsTrue(pBoolean)) bBoolean = TRUE;
        else bBoolean = FALSE;
        
        
        pWelcomMessage = PyObject_GetAttrString(pModule, "szWelcomMessage");
        pWhoamI = PyObject_GetAttrString(pModule, "szWhoamI");
        
        PyArg_Parse(pWelcomMessage, "s", &szWelcomMessage);
        PyArg_Parse(pWhoamI, "s", &szWhoamI);
        
        NSLog(@"[myfunc_4]Return 1 = %s\n", szReturnString);
        NSLog(@"[myfunc_4]Return 2 = %s\n", (TRUE == bBoolean)? "TRUE" : "FALSE" );
        NSLog(@"[myfunc_4]szWelcomMessage = %s\n", szWelcomMessage);
        NSLog(@"[myfunc_4]szWhoamI = %s\n\n", szWhoamI);
        
        
        
        
        /////////////////////////////////////////////////////////////
        //
        // Call myfunc_5
        //
        NSLog(@"[myfunc_5]========================================");
        pFunction_05 = PyObject_GetAttrString(pModule, "myfunc_5");
        if (NULL == pFunction_05)
            [NSException raise:@"PyObject_GetAttrString" format:@"[%s]PyObject_GetAttrString = NULL", "myfunc_5"];
        pArgument = PyTuple_Pack(2, PyUnicode_FromFormat("%s", "myfunc_5"), Py_False);
        pReturn = PyObject_CallObject(pFunction_05, pArgument);
        if (NULL != pArgument) Py_DECREF(pArgument);
        pArgument = NULL;
        if (NULL == pReturn)
            [NSException raise:@"PyObject_CallObject" format:@"[%s]PyObject_CallObject = NULL", "myfunc_5"];
        if (FALSE == PyTuple_Check(pReturn))
            [NSException raise:@"PyObject_CallObject" format:@"[%s]pFunction_02 != Tuple", "myfunc_5"];
        
        PyArg_Parse(PyTuple_GetItem(pReturn, 0), "s", &szReturnString);
        
        pBoolean = PyTuple_GetItem(pReturn, 1);
        if (1 == PyObject_IsTrue(pBoolean)) bBoolean = TRUE;
        else bBoolean = FALSE;
        
        
        pWelcomMessage = PyObject_GetAttrString(pModule, "szWelcomMessage");
        pWhoamI = PyObject_GetAttrString(pModule, "szWhoamI");
        
        PyArg_Parse(pWelcomMessage, "s", &szWelcomMessage);
        PyArg_Parse(pWhoamI, "s", &szWhoamI);
        
        NSLog(@"[myfunc_5]Return 1 = %s\n", szReturnString);
        NSLog(@"[myfunc_5]Return 2 = %s\n", (TRUE == bBoolean)? "TRUE" : "FALSE" );
        NSLog(@"[myfunc_5]szWelcomMessage = %s\n", szWelcomMessage);
        NSLog(@"[myfunc_5]szWhoamI = %s\n\n", szWhoamI);
        
        
        
        bSuccess = true;
    }
    @catch (NSException *exception)  {
        NSLog( @"NSException caught" );
        NSLog( @"Name: %@", exception.name);
        NSLog( @"Reason: %@", exception.reason );
    }
    @finally {
        
        if (NULL!= pModule) Py_DecRef(pModule);
        Py_Finalize();
    }
    
    NSLog(@"Leave %@", NSStringFromSelector(_cmd));
}


static PyObject *MyDbgString1(PyObject *pSelf)
{
    PyObject * pReturn = NULL;
    
    NSLog(@"MyDbgString 호출됨");
    Py_INCREF(Py_None);
    pReturn = Py_None;
    
    return pReturn;
}

static PyMethodDef ExtMethods1[] = {
    { "DbgString", (PyCFunction)MyDbgString1, METH_NOARGS, "Execute a OutputDebugString"},
    {NULL, NULL, 0, NULL}
};

static struct PyModuleDef PyExtModule1 = {
    PyModuleDef_HEAD_INIT,
    "PyExt",
    NULL,
    -1,
    ExtMethods1
};


PyMODINIT_FUNC PyInit_Ext1(void)
{
    return PyModule_Create(&PyExtModule1);
}

- (IBAction)Button_4_Click:(id)sender {
    bool bSuccess = false;
    
    PyObject *pModule = NULL;
    
    NSLog(@"Enter %@", NSStringFromSelector(_cmd));
    
    @try {
        PyImport_AppendInittab("PyExt", PyInit_Ext1);
        Py_Initialize();
        Append_Script_Path();
        
        pModule = PyImport_ImportModule("Sample04");
        if (NULL == pModule) {
            [NSException raise:@"PyImport_ImportModule" format:@"PyImport_ImportModule = %d", (int)pModule];
        }
        
        
        bSuccess = true;
    }
    @catch (NSException *exception)  {
        NSLog( @"NSException caught" );
        NSLog( @"Name: %@", exception.name);
        NSLog( @"Reason: %@", exception.reason );
    }
    @finally {
        if (NULL!= pModule) Py_DecRef(pModule);
        Py_Finalize();
    }
    
    NSLog(@"Leave %@", NSStringFromSelector(_cmd));
}


static PyObject *MyDbgString2(PyObject *pSelf, PyObject *pArg)
{
    PyObject *	pReturn = NULL;
    char *		szDbgString;
    /* Treat arg as a borrowed reference. */
    Py_INCREF(pArg);
    
    PyArg_Parse(pArg, "s", &szDbgString);
    NSLog(@"%s", szDbgString);
    
    Py_INCREF(Py_None);
    pReturn = Py_None;
    
    return pReturn;
}

static PyObject *MySum(PyObject *pSelf, PyObject *pArg)
{
    PyObject *	pReturn = NULL;
    int			nStartVar = 0;
    int			nStopVar = 0;
    int			nSum = 0;
    
    /* Treat arg as a borrowed reference. */
    Py_INCREF(pArg);
    
    PyArg_ParseTuple(pArg, "II", &nStartVar, &nStopVar);
    
    for (int nIndex = nStartVar; nIndex <= nStopVar; nIndex++)
    {
        nSum += nIndex;
    }
    
    pReturn = PyLong_FromUnsignedLong(nSum);
    
    return pReturn;
}

static PyMethodDef ExtMethods2[] = {
    { "DbgString",  (PyCFunction)MyDbgString2, METH_O, "Execute a OutputDebugString" },
    { "Sum",  (PyCFunction)MySum, METH_VARARGS, "Execute a OutputDebugString" },
    { NULL, NULL, 0, NULL }
};


static struct PyModuleDef PyExtModule2 = {
    PyModuleDef_HEAD_INIT,
    "PyExt",
    NULL,
    -1,	
    ExtMethods2
};


PyMODINIT_FUNC PyInit_Ext2(void)
{
    return PyModule_Create(&PyExtModule2);
}

- (IBAction)Button_5_Click:(id)sender {
    bool bSuccess = false;
    
    PyObject *pModule = NULL;
    
    NSLog(@"Enter %@", NSStringFromSelector(_cmd));
    
    @try {
        PyImport_AppendInittab("PyExt", PyInit_Ext2);
        Py_Initialize();
        Append_Script_Path();
        
        pModule = PyImport_ImportModule("Sample05");
        if (NULL == pModule) {
            [NSException raise:@"PyImport_ImportModule" format:@"PyImport_ImportModule = %d", (int)pModule];
        }
        
        
        bSuccess = true;
    }
    @catch (NSException *exception)  {
        NSLog( @"NSException caught" );
        NSLog( @"Name: %@", exception.name);
        NSLog( @"Reason: %@", exception.reason );
    }
    @finally {
        
        if (NULL!= pModule) Py_DecRef(pModule);
        Py_Finalize();
    }
    
    NSLog(@"Leave %@", NSStringFromSelector(_cmd));
}


static PyObject *MyDbgString3(PyObject *pSelf, PyObject *pArg)
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

static PyObject *MySumAndAverage(PyObject *pSelf, PyObject *pArg)
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

static PyMethodDef ExtMethods3[] = {
    { "DbgString",  (PyCFunction)MyDbgString3, METH_O, "Execute a OutputDebugString" },
    { "SumAndAverage",  (PyCFunction)MySumAndAverage, METH_VARARGS, "Execute a OutputDebugString" },
    { NULL, NULL, 0, NULL }
};


static struct PyModuleDef PyExtModule3 = {
    PyModuleDef_HEAD_INIT,
    "PyExt",
    NULL,
    -1,	
    ExtMethods3
};


PyMODINIT_FUNC PyInit_Ext3(void)
{
    return PyModule_Create(&PyExtModule3);
}

- (IBAction)Button_6_Click:(id)sender {
    bool bSuccess = false;
    
    PyObject *  pModule = NULL;

    
    NSLog(@"Enter %@", NSStringFromSelector(_cmd));
    @try {
        PyImport_AppendInittab("PyExt", PyInit_Ext3);
        Py_Initialize();
        Append_Script_Path();
        
        pModule = PyImport_ImportModule("Sample06");
        if (NULL == pModule) {
            [NSException raise:@"PyImport_ImportModule" format:@"PyImport_ImportModule = %d", (int)pModule];
        }
        
        
        bSuccess = true;
    }
    @catch (NSException *exception)  {
        NSLog( @"NSException caught" );
        NSLog( @"Name: %@", exception.name);
        NSLog( @"Reason: %@", exception.reason );
    }
    @finally {
        
        if (NULL!= pModule) Py_DecRef(pModule);
        Py_Finalize();
    }
    
    NSLog(@"Leave %@", NSStringFromSelector(_cmd));
}


- (IBAction)Button_7_Click:(id)sender {
    bool bSuccess = false;
    
    PyObject *  pModule = NULL;
    void *      hPyExt = NULL;
    
    PyMODINIT_FUNC (*InitPyExt)(void);
    static PyObject *(*DbgString)(PyObject *pSelf, PyObject *pArg) = NULL;
    static PyObject *(*SumAndAverage)(PyObject *pSelf, PyObject *pArg) = NULL;
    
    
    NSLog(@"Enter %@", NSStringFromSelector(_cmd));
    @try {
        hPyExt = dlopen("./Script/libPyExt.dylib", RTLD_LOCAL|RTLD_LAZY);
        if (NULL == hPyExt) {
            NSLog(@"[%s] Unable to load library: %s\n", __FILE__, dlerror());
            return;
        }
        
        InitPyExt = dlsym(hPyExt, "InitPyExt");
        if (NULL == InitPyExt) {
            NSLog(@"[%s] Unable to get symbol: %s\n", __FILE__, dlerror());
            return;
        }
        
        PyImport_AppendInittab("PyExt", InitPyExt);
        Py_Initialize();
        Append_Script_Path();
        
        pModule = PyImport_ImportModule("Sample07");
        if (NULL == pModule) {
            [NSException raise:@"PyImport_ImportModule" format:@"PyImport_ImportModule = %d", (int)pModule];
        }
        
        
        bSuccess = true;
    }
    @catch (NSException *exception)  {
        NSLog( @"NSException caught" );
        NSLog( @"Name: %@", exception.name);
        NSLog( @"Reason: %@", exception.reason );
    }
    @finally {
        
        if (NULL!= pModule) Py_DecRef(pModule);
        Py_Finalize();
    }
    
    NSLog(@"Leave %@", NSStringFromSelector(_cmd));
}

@end
