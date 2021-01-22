
int main() {
  volatile unsigned int *ptr = (unsigned int *)0x00010000;
  *ptr = 0b00000000000000000000000000100101;

  while(1) {
    for (unsigned int i = 0; i < 255; i++) {
      for (unsigned int j = 0; j < 1000000; j++);
      *ptr = i;
      
    }
  }
  
  
  //while(1);
}
