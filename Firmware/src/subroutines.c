#include <stdint.h>
#include "plattform.h"

const int SLEEP_CYCLES = 1000000;

void sleep(int delay_cycles);
uint8_t increment(uint8_t value);

int main()
{
  // clear LED
  LED = 0;
  while (1)
  {
    // Sleep
    sleep(SLEEP_CYCLES);
    // Clear LED if counter reach max
    if (LED == 255)
    {
      LED = 0;
    }
    else
    {
      // Read LED value and add one to it
      LED = increment(LED);
    }
  }
  return 0;
}

uint8_t increment(uint8_t value)
{
  return value + 1;
}

void sleep(int delay_cycles)
{
  for (volatile int i = 0; i < delay_cycles; i++)
    ;
}