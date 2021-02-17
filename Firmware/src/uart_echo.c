#include "plattform.h"


int main() {
    while (1) {

    while (UART_STATUS & 0b10 != 0);
    char rx = UART_RX;
    if (rx >= '0' && rx <= '9') {
        LED = '0' - rx;
        UART_TX = rx;
        while (UART_STATUS & 1 == 1);
    }
    }
}