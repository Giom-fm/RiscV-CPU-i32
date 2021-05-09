#include <stdbool.h>
#include "plattform.h"

const int SLEEP_CYCLES = 1000000;

int main() {
   // Set LED to startvalue and set start direction
  LED = 1;
  bool direction_up = true;
   // infinti loop
  while (1) {
    for (int i = 0; i < SLEEP_CYCLES; i++)
      ;

    if (direction_up) {
      // Multiply
      LED *= 2;
      // If maxvalue change direction
      if (LED == (128)) {
        direction_up = false;
      }
    } else {
      // Devide
      LED /= 2;
       // If minvalue change direction
      if (LED == 1) {
        direction_up = true;
      }
    }
  }
  return 0;
}