int main() {
  int counter = 1;
  while (1) {
    for (int i = 0; i < 1000000; i++)
      ;
    if (counter == (1 << 7)) {
      counter = 1;
    } else {
      counter <<= 1;
    }
  }
  return 0;
}