#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>

extern void welcome(char *a, char *b, int c);

int check_Hex(const char *str) {
  for(int i=0; str[i] != '\0'; i++) {
    if (!isxdigit(str[i])) {
      return 0;
    }
  }
  return 1;
}
int main (int argc, char *argv[]){
  if (argc !=4) {
    printf ("Podano nieprawidlowa liczbe argumentow.\n");
    return 1;
  }
//argv [1] to pierwszy parametr (adres stringa)
//argv [2] to znak jako string
//argv [3] to 2. string
char *num1 = argv[1];
char *znak = argv[2];
char *num2 = argv[3];
//Obliczenie dlugosci stringów
int strlen1 = strlen(num1);
int strlen2 = strlen(num2);
printf("%d\n", strlen1);
printf("%d\n", strlen2);
//printf ("Num2 to %d\n", strlen2);

if (check_Hex(num1)){
  printf ("Podano prawidlowa wartosc hexadecymalna.\n");
}
else {
  printf ("Podano nieprawidlowa liczbe\n");
  return 1;
}
if (check_Hex(num2)){
  printf ("Podano prawidlowa wartosc hexadecymalna.\n");
}
else {
  printf ("Podano nieprawidlowa liczbe\n");
  return 1;
}

if (*znak != '+') {
    printf("Przepraszam nie wykonuje takiej operacji. Moge tylko dodawac.\n");
  return 1;
  }
//deklarujemy dynamicznie tablice wynikowa i przepisana
char *wynik;
char *przepisana;

if (strlen1 >= strlen2){
  size_t n = strlen1 + 1;
  wynik = (char*)malloc(n*sizeof(char));
}
else {
  size_t n = strlen2 + 1;
  wynik = (char*)malloc(n*sizeof(char));
}
if (wynik == NULL) {
  printf("Blad alokacji pamieci. Sprawdz deklaracje tablicy wynik\n");
  return 1;
}



if (strlen1 >= strlen2){
  size_t n = strlen1 + 1;
  przepisana = (char*)malloc(n*sizeof(char));
}
else {
  size_t n = strlen2 + 1;
  przepisana = (char*)malloc(n*sizeof(char));
}

if (przepisana == NULL) {
  printf("Blad alokacji pamieci. Sprawdz deklaracje tablicy wynik\n");
  return 1;
}

printf("Tutaj jestem\n");

for (int i=0; i<srtlen1;i++){
  wynik[i+1]=num1[i]
}
//przepisanie poprawne tablicy
if (strlen1>=strlen2) {
for (int i=0; i<srtlen1;i++){
  przepisana[i+1]=num2[i]
}
for (int i = 0; i<(strlen2+1);i++){
printf ("%c",przepisana[i]);
}
}
for (int i = 0; i<(strlen1+1);i++){
printf ("%c",wynik[i]);
}
for (int i = 0; i<(strlen2+1);i++){
printf ("%c",przepisana[i]);
}




if (strlen1 >= strlen2){
 welcome(wynik, przepisana, strlen1);
}
else{
 welcome(wynik, przepisana, strlen2);
}

printf("A tutaj nie jestem\n");

for (int i = 0; i<strlen1;i++){
printf ("%x",num1[i]);
}
printf("\n");

for (int i = 0; i<strlen2;i++){
printf ("%x",num2[i]);
}
printf("\n");

for (int i = 0; i<(strlen1+1);i++){
printf ("%c",wynik[i]);
}
printf("\n");

for (int i = 0; i<(strlen2+1);i++){
printf ("%c",przepisana[i]);
}
printf("\n");


free(wynik);
free(przepisana);

return 0;
}


//są stringi, są długości, są stringi jako tablice
