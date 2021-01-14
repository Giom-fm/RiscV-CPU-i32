int main() {
  register int counter = 0;
  while (1) {
    for (int i = 0; i < 1000000; i++)
      ;

    if (counter == 255) {
      counter = 0;
    } else {
      counter += 1;
    }
  }
  return 0;
}