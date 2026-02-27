#include <stdio.h>
#include <stdint.h>

#define BIGEDIAN

int main()
{
    // Number - 8128420482184
    uint32_t tmp[2] = 
    {
#ifdef BIGEDIAN
        0x9D8BC888, 0x00000764
#else
        0x00000764, 0x8B9D8C88
#endif
    };

    uint64_t *val = (uint64_t *)&tmp[0];

    printf("Value is %llu.\n", *val);

    return 0;
}
