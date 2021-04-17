#ifndef PLATTFORM_H
#define PLATTFORM_H

#include <stdint.h>

#define LED_ADDRESS 0x00010000
#define LED (*((volatile uint8_t *)(LED_ADDRESS)))

#define UART_RX_ADDRESS 0x00010001
#define UART_RX (*((volatile uint8_t *)(UART_RX_ADDRESS)))

#define UART_TX_ADDRESS 0x00010002
#define UART_TX (*((volatile uint8_t *)(UART_TX_ADDRESS)))

#define UART_STATUS_ADDRESS 0x00010003
#define UART_STATUS (*((volatile uint8_t *)(UART_STATUS_ADDRESS)))

#endif /* PLATTFORM_H */
