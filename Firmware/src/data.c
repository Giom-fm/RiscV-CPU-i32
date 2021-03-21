#include "plattform.h"

volatile uint8_t i1 = 42;
volatile const uint8_t i2 = 42;
volatile static uint8_t i3 = 42;
volatile static const uint8_t i4 = 42;

volatile char *s1 = "Test1";
//volatile const char *s2 = "Test2";
//volatile static char *s3 = "Test3";
//volatile static const char *s4 = "Test4";

int main(void)
{

    i1 = 4;
    while (1)
        ;

    return 0;
}
