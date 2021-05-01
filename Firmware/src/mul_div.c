#include <stdbool.h>
#include "plattform.h"

const int SLEEP_CYCLES = 1000000;

int main() {
  LED = 1;
  bool direction_up = true;
  while (1) {
    for (int i = 0; i < SLEEP_CYCLES; i++)
      ;
    if (direction_up) {
      LED *= 2;
      if (LED == (128)) {
        direction_up = false;
      }
    } else {
      LED /= 2;
      if (LED == 1) {
        direction_up = true;
      }
    }
  }
  return 0;
}