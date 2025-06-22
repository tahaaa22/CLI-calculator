#ifndef CALCULATOR_H
#define CALCULATOR_H

#include <Python.h>
#include "calc.h"

// Python wrapper function declarations
static PyObject *py_add(PyObject *self, PyObject *args);
static PyObject *py_sub(PyObject *self, PyObject *args);
static PyObject *py_mul(PyObject *self, PyObject *args);
static PyObject *py_divide(PyObject *self, PyObject *args);
static PyObject *py_power(PyObject *self, PyObject *args);
// Module initialization function
PyMODINIT_FUNC PyInit__calc(void);

#endif // CALCULATOR_H