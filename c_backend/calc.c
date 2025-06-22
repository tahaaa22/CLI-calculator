#include "calc.h"

double add(double num1, double num2)
{
    return num1 + num2;
}

double sub(double num1, double num2)
{
    return num1 - num2;
}

double mul(double num1, double num2)
{
    return num1 * num2;
}

double divide(double num1, double num2)
{
    return num2 == 0 ? 0 : num1 / num2;
}

double power(double base, double exponent)
{
    double result = 1.0;
    for (int i = 0; i < exponent; i++)
    {
        result *= base;
    }
    return result;
}