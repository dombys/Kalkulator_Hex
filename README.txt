Kalkulator 100 bajtowych hexadecymalnych liczb
Funkcje, które mają zostać zaimplementowane:
- Mnożenie prze 1+ char (1 byte Hex do 100 byte Hex)
- Dzielenie (dzielenie tylko przez dzielniku 4 bajtowym)*

Częściowo ziamplementowane funkcje:
- Mnożenie przez 1 chara -> działa dla liczb 0-9 oraz A (gubi przeniesienie z pierwszego mnożenia przy pozostałych literkach)
UWAGA:
Sposób przedstawienia wyniku - wypisywanie dużej ilości 0 prawostronnie od wyniku spodziewanego jest spodowane uzależnieniem wypisywania wyniku od podwójnej długości liczby A; obecnie mnożenie zaimplementowano z myślą o podaniu dłuższej liczby jako liczby A a krótszej jako liczby B


Obecnie zaimplementowane elementy programu:
- pobieranie wymaganych argumentów ze stacka
- wpisywanie liczb w odpowiednie tablice, ich konwersja z ASCII do HEX
- podstawowa obsługa błędów - jeżeli podano zły znak (lub literę) program zakończy działanie
- wypisywane są podane argumenty w terminalu
- Konwersja wyniku z hex na ASCII
- Wypisanie wyniku
- Dodawanie
- Odejmowanie

Na potrzeby zadania i uporządkowania stworzono foldery zawierające Makefile dla:
calcasm -> kalkulator bez początkowej implementacji dzielenia (z błędnym mnożeniem/brakiem mnożenia przez więcej niż 1 liczbę)

calcasmd -> kalkulator z początkową implementacją dzielenia (z błędnym mnożeniem/brakiem mnożenia przez więcej niż 1 liczbę)


Byte by byte to the result.
At least regarding addition and subtraction.
*obecnie zaimplementowano kontrolę błędów -> czy Num2 jest 0 oraz proste "dzielenie" gdy Num1 (dzielna) jest krótszy od Num2 (dzielnik)
