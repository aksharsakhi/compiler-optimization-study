/* Performance with incrementing and dividing an 8-bit integer */
#include <stdio.h>
#include <stdint.h>

int main() {
    uint8_t value = 0;

    value += 30;
    value /= 10;

    printf("Value is %d.\n", value);

    return 0;
}
