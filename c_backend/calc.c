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