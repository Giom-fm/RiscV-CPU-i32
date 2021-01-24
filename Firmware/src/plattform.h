#ifndef PLATTFORM_H
#define PLATTFORM_H

#include <stdint.h>

//#define LED_ADDRESS 0x00010000
//#define LED (*((volatile unsigned int *) (LED_ADDRESS)))

#define LED_ADDRESS 0x00010000
#define LED (*((volatile uint8_t  *) (LED_ADDRESS)))

#endif /* PLATTFORM_H */



