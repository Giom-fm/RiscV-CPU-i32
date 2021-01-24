#include "plattform.h"

int main() {
  while (1) {
    for (unsigned int i = 0; i < 255; i++) {
      for (unsigned int j = 0; j < 1000000; j++)
        ;
      LED = i;
    }
  }

  // while(1);
}