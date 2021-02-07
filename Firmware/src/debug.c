#include "plattform.h"

int main(void) {
  volatile register uint8_t test = 0;

  if (test == 0) {
    LED = 0b10000001;
  } else {
    LED = 0b00010000;
  }

  /*
  uint8_t* mem_ptr = (uint8_t*)0x0;

  for (register uint8_t i = 0; i < 0xFF; i++) {
    LED = mem_ptr[i];
    UART_TX = mem_ptr[i];
    for (register int j = 0; j < 10000000; j++)
      ;
  }

*/
  while (1)
    ;

  return 0;
}
