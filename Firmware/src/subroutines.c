#include <stdint.h>

#include "plattform.h"

void sleep(int delay_cycles);

int main() {
  LED = 0;

  while (1) {
    sleep(100000);
    LED += 1;
  }

  return 0;
}


void sleep(int delay_cyclces) {
  for (int i = 0; i < delay_cyclces; i++)
    ;
}
