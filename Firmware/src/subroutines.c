#include <stdint.h>
#include "plattform.h"

void sleep(int delay_cyclces);

int main(void) {
  LED = 0;

  while (1) {
    sleep(100000);
    LED += 1;
  }

  return 0;
}

void sleep(int delay_time) {
  for (volatile int i = 0; i < delay_time; i++)
    ;
}