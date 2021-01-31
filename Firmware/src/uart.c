#include "plattform.h"

int main() {
  while (1) {
    /*
while (UART_STATUS & 0b10 != 0)
  ;
  char rx = UART_RX;
  if (rx != 0) {
    LED = rx - 32;
  }

    */

    for (unsigned char i = 'a'; i <= 'z'; i++) {
      for (unsigned int j = 0; j < 2000000; j++)
        ;
      LED = i;
      UART_TX = i;
      while (UART_STATUS & 1 == 1)
        ;
    }
  }

  // while(1);
}