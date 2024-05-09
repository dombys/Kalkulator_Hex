#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>

extern void welcome(int *a, int *b, int c);

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
//printf("%d\n", strlen1);
//printf("%d\n", strlen2);
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
int *wynik;
int *przepisana;
int *Num1;
int *Num2;

if (strlen1 >= strlen2){
  size_t n = strlen1 + 1;
  wynik = (int*)malloc(n*sizeof(int));
}
else {
  size_t n = strlen2 + 1;
  wynik = (int*)malloc(n*sizeof(int));
}
if (wynik == NULL) {
  printf("Blad alokacji pamieci. Sprawdz deklaracje tablicy wynik\n");
  return 1;
}

if (strlen1 >= strlen2){
  size_t n = strlen1 + 1;
  przepisana = (int*)malloc(n*sizeof(int));
}
else {
  size_t n = strlen2 + 1;
  przepisana = (int*)malloc(n*sizeof(int));
}

if (przepisana == NULL) {
  printf("Blad alokacji pamieci. Sprawdz deklaracje tablicy przepisana\n");
  return 1;
}

if (strlen1 >= strlen2){
  size_t n = strlen1 + 1;
  Num1 = (int*)malloc(n*sizeof(int));
}
else {
  size_t n = strlen2 + 1;
  Num1 = (int*)malloc(n*sizeof(int));
}

if (przepisana == NULL) {
  printf("Blad alokacji pamieci. Sprawdz deklaracje tablicy Num1\n");
  return 1;
}

if (strlen1 >= strlen2){
  size_t n = strlen1 + 1;
  Num2 = (int*)malloc(n*sizeof(int));
}
else {
  size_t n = strlen2 + 1;
  Num2 = (int*)malloc(n*sizeof(int));
}

if (przepisana == NULL) {
  printf("Blad alokacji pamieci. Sprawdz deklaracje tablicy Num2\n");
  return 1;
}


for (int i=0; i <strlen1; i++){
char c = num1[i];
  if (c <='9'){
    Num1[i+1] = c - '0';
  }
  else if (c <='F') {
    Num1[i+1] = c - 'A' + 10;
  }
  else if (c <='f') {
    Num1[i+1] = c - 'a' + 10;
  }
}
// konwersja drugiej liczby
for (int i=0; i <strlen2; i++){
char c = num2[i];
  if (c <='9'){
    Num2[i+1] = c - '0';
  }
  else if (c <='F') {
    Num2[i+1] = c - 'A' + 10;
  }
  else if (c <='f') {
    Num2[i+1] = c - 'a' + 10;
  }
}



/*if (strlen1==strlen2) {
for (int i=0;i<strlen1+1;i++){
  wynik[i]=num1[i];
}
//przepisanie poprawne tablicy
for (int i=0; i<strlen1+1;i++){
  przepisana[i]=num2[i];
}
}
if (strlen1>strlen2) {
for (int i=0; i<strlen1+1;i++){
  wynik[i]=num1[i];
}
int roznica = strlen1-strlen2;
for (int i=0; i<(strlen2+roznica);i++){
  przepisana[i+1]=num2[i];
}
}
if (strlen1<strlen2) {
int roznica = strlen2-strlen1;
for (int i=0; i<(strlen1+roznica);i++){
  wynik[i+1]=num1[i];
}
for (int i=0; i<strlen2;i++){
  przepisana[i]=num2[i];
}

}*/
/*
for (int i = 0; i<strlen1+1;i++){
printf ("%d",wynik[i]);
}
printf("\n");

for (int i = 0; i<strlen2+1;i++){
printf ("%d",przepisana[i]);
}
printf("\n");
*/

if (strlen1 >= strlen2){
 welcome(Num1, Num2, strlen1);
}
else{
 welcome(Num1, Num2, strlen2);
}

printf("A tutaj nie jestem\n");

for (int i = 0; i<strlen1+1;i++){
printf ("%x",Num1[i]);
}
printf("\n");

for (int i = 0; i<strlen2+1;i++){
printf ("%x",Num2[i]);
}
printf("\n");

/*for (int i = 0; i<(strlen1+1);i++){
printf ("%x",wynik[i]);
}
printf("\n");

for (int i = 0; i<(strlen2+1);i++){
printf ("%x",przepisana[i]);
}
printf("\n");
*/
//zwolnienie pamieci
free(wynik);
free(przepisana);
free(Num1);
free(Num2);
return 0;
}


//są stringi, są długości, są stringi jako tablice
