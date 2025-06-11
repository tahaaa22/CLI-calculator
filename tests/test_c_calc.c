#include <stdio.h>
#include "../c_backend/calc.h"

int main()
{
    printf("Testing C Backend Functions...\n");

    if (add(2, 3) != 5.0)
    {
        printf("add failed\n");
        return 1;
    }
    if (sub(5, 3) != 2.0)
    {
        printf("sub failed\n");
        return 1;
    }
    if (mul(2, 3) != 6.0)
    {
        printf("mul failed\n");
        return 1;
    }
    if (divide(6, 3) != 2.0)
    {
        printf("divide failed\n");
        return 1;
    }
    if (divide(5, 0) != 0.0)
    {
        printf("divide by zero failed\n");
        return 1;
    }

    printf("All C tests passed!\n");
    return 0;
}
