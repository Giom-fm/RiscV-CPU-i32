#include <stdbool.h>

#include "plattform.h"

const int SLEEP_CYCLES = 1000000;

int main() {
  // Infiniti Loop
  while (1) {
    LED = 0;
    recursion();
  }
}

void recursion() {
  LED += 1;
  for (int i = 0; i < SLEEP_CYCLES; i++)
    ;
  if (LED < 255) {
    recursion();
  }
}
