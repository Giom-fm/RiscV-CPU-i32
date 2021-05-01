#include "plattform.h"

const int SLEEP_CYCLES = 1000000;

int main() {
  // clear LED
  LED = 0;
  while (1) {
    // Sleep
    for (register int i = 0; i < SLEEP_CYCLES; i++)
      ;
    // Clear LED if counter reach max
    if (LED == 255) {
      LED = 0;
    } else {
      // Read LED value and add one to it
      LED += 1;
    }
  }
  return 0;
}