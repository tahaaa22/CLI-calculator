#define PY_SSIZE_T_CLEAN
#include <Python.h>
#include "calc.h"

/**
 * @brief Wrapper for the add function.
 *
 * Adds two double-precision floating point numbers provided as Python arguments.
 *
 * @param self Unused.
 * @param args Tuple containing two doubles.
 * @return Python float representing the sum, or NULL on failure.
 */
static PyObject *py_add(PyObject *self, PyObject *args)
{
    double a, b;
    // Parse two double arguments from Python
    if (!PyArg_ParseTuple(args, "dd", &a, &b))
        return NULL;

    // Call the C add function and return the result as a Python float
    return PyFloat_FromDouble(add(a, b));
}

/**
 * @brief Wrapper for the sub function.
 *
 * Subtracts the second double from the first, both provided as Python arguments.
 *
 * @param self Unused.
 * @param args Tuple containing two doubles.
 * @return Python float representing the difference, or NULL on failure.
 */
static PyObject *py_sub(PyObject *self, PyObject *args)
{
    double a, b;
    if (!PyArg_ParseTuple(args, "dd", &a, &b))
        return NULL;
    return PyFloat_FromDouble(sub(a, b));
}

/**
 * @brief Wrapper for the mul function.
 *
 * Multiplies two double-precision floating point numbers provided as Python arguments.
 *
 * @param self Unused.
 * @param args Tuple containing two doubles.
 * @return Python float representing the product, or NULL on failure.
 */
static PyObject *py_mul(PyObject *self, PyObject *args)
{
    double a, b;
    if (!PyArg_ParseTuple(args, "dd", &a, &b))
        return NULL;
    return PyFloat_FromDouble(mul(a, b));
}

/**
 * @brief Wrapper for the divide function.
 *
 * Divides the first double by the second, both provided as Python arguments.
 *
 * @param self Unused.
 * @param args Tuple containing two doubles.
 * @return Python float representing the quotient, or NULL on failure.
 */
static PyObject *py_divide(PyObject *self, PyObject *args)
{
    double a, b;
    if (!PyArg_ParseTuple(args, "dd", &a, &b))
        return NULL;
    return PyFloat_FromDouble(divide(a, b));
}

/**
 * @brief Method definitions for the calculator module.
 */
static PyMethodDef CalcMethods[] = {
    {"add", py_add, METH_VARARGS, "Add two numbers"},
    {"sub", py_sub, METH_VARARGS, "Subtract two numbers"},
    {"mul", py_mul, METH_VARARGS, "Multiply two numbers"},
    {"divide", py_divide, METH_VARARGS, "Divide two numbers"},
    {NULL, NULL, 0, NULL}};

/**
 * @brief Module definition structure for the calculator module.
 */
static struct PyModuleDef calcmodule = {
    PyModuleDef_HEAD_INIT,
    "_calc",
    "C-backed calculator module",
    -1,
    CalcMethods};

/**
 * @brief Module initialization function.
 *
 * Initializes the _calc module for Python.
 *
 * @return A new module object, or NULL on failure.
 */
PyMODINIT_FUNC PyInit__calc(void)
{
    return PyModule_Create(&calcmodule);
}