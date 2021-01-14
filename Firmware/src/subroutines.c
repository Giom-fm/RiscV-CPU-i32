
void sleep(int delay_cycles);

int main() {
  int counter = 0;
  while (1) {

   sleep(1000000);

    if (counter == 255) {
      counter = 0;
    } else {
      counter += 1;
    }
  }

  return 0;
}

void sleep(int delay_cyclces) {
  for (int i = 0; i < delay_cyclces; i++)
    ;
}