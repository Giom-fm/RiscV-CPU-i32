#include "plattform.h"

int main(void) {
  uint8_t* mem_ptr = (uint8_t*)0x0;

  for (register uint8_t i = 0; i < 0xFF; i++) {
    UART_TX = mem_ptr[i];
    LED = mem_ptr[i];
    for (register uint32_t j = 0; j < 1000000; ++j)
      ;
  }

  while (1)
    ;

  return 0;
}
