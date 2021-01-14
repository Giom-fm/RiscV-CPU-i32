#include "stdbool.h"

int main() {
  int counter = 1;
  bool direction_up = true;
  while (1) {
    for (int i = 0; i < 1000000; i++)
      ;
    if (direction_up) {
      counter <<= 1;
      if (counter == (1 << 7)) {
        direction_up = false;
      }
    } else {
      counter >>= 1;
      if (counter == 1) {
        direction_up = true;
      }
    }
  }
  return 0;
}