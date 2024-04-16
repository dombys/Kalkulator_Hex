section .data
msg db 'Dodaje', 0xa
msg_len equ $ -msg

msgo db 'Odejmuje', 0xa
msgo_len equ $ -msgo

msgm db 'Mnoze', 0xa
msgm_len equ $ -msgm

newline db 0xa
newline_len equ $ -newline

msgerr1 db 'Podano zly znak', 0xa
msg_lenerr1 equ $ -msgerr1

msgerr2 db 'Podano zla dana, sprawdz podane argumenty', 0xa
msg_lenerr2 equ $ -msgerr2


nel db 0xa
nel_len equ $ -nel

strlen1 times 8 db 0
strlen2 times 8 db 0
strlen1hex times 8 db 0
strlen2hex times 8 db 0
przeniesieniedanych times 8 db 0
Num1_arr times 201 db 0
Num2_arr times 201 db 0
Hex1_arr times 101 db 0
Hex2_arr times 101 db 0
PrzepisanaLiczba_arr times 101 db 0
Wynik_arr times 1000 db 0
Wypisz_arr times 1000 db 0

global _start
section .text

_start:
push ebp ;zapisujemy wskazanie ebp na stacku
mov ebp, esp ;przesuwamy ebp do poczatku, aby zlapac nasze argumenty

;dopasc num1
mov ecx, [ebp + 12]
mov eax, ecx
xor ebx,ebx
strlen_znajdz:
cmp byte [eax+ebx],0
je strlenmam
inc ebx
jmp strlen_znajdz
strlenmam:
mov [strlen1], ebx ;obliczonego strlena liczby1 daje do pamięci
mov edx, [strlen1]
call wypisz
call nl

;wpiszdoarraya
call czyscrejestr
xor esi, esi
xor edi, edi
mov esi, [ebp + 12]
mov edi, Num1_arr
mov ecx, [strlen1]
WpiszNum1:
mov al, [esi]
mov [edi+1], al
inc esi
inc edi
dec ecx
jnz WpiszNum1

;converttoHex1
xor edi, edi
mov edi, Num1_arr
mov ecx, [strlen1]
call converHex

createHex1:
call czyscrejestr
xor esi, esi
xor edi, edi
mov esi, Num1_arr
mov edi, Hex1_arr
OneByteStrlen1:
mov ecx, [strlen1]
cmp ecx, 1 ;sprawdz czy 1 znak wpisano
je onebyteHex1
wincejniz1bajtstrlen1:
mov eax, [strlen1]
and eax, 1
mov ecx, [strlen1]
add ecx, eax
shr ecx, 1
mov [strlen1hex], ecx
mov edx, [strlen1]
call combineHex
jmp znak

;dopasc znak
znak:
mov ecx, dword [ebp + 16]
mov al, [ecx]
cmp al, '+'
je dodaj

mov al, [ecx]
cmp al, '-'
je odejmij

mov al, [ecx]
cmp al, '*'
je mnoz
jne zly_znak

dodaj:
mov edx, 1
call wypisz
call nl
jmp num2

odejmij:
mov edx, 1
call wypisz
call nl
jmp num2

mnoz:
mov edx, 1
call wypisz
call nl
jmp num2

;dopasc num2
num2:
mov ecx, [ebp + 20]
xor ebx,ebx
mov eax, ecx
strlen_znajdz2:
cmp byte [eax+ebx],0
je strlenmam2
inc ebx
jmp strlen_znajdz2
strlenmam2:
mov [strlen2], ebx ;obliczonego strlena liczby1 daje do pamięci
mov edx, [strlen2]
call wypisz
call nl

;wpiszdoarrayaNum2
call czyscrejestr
xor esi, esi
xor edi, edi
mov esi, [ebp + 20]
mov edi, Num2_arr
mov ecx, [strlen2]
WpiszNum2:
mov al, [esi]
mov [edi+1], al
inc esi
inc edi
dec ecx
jnz WpiszNum2

;converttoHex2
xor edi, edi
mov edi, Num2_arr
mov ecx, [strlen2]
call converHex

createHex2:
call czyscrejestr
xor esi, esi
xor edi, edi
mov esi, Num2_arr
mov edi, Hex2_arr
OneByteStrlen2:
mov ecx, [strlen2]
cmp ecx, 1 ;sprawdz czy 1 znak wpisano
je onebyteHex
wincejniz1bajtstrlen2:
mov eax, [strlen2]
and eax, 1
mov ecx, [strlen2]
add ecx, eax
shr ecx, 1
mov [strlen2hex], ecx
mov edx, [strlen2]
call combineHex
jmp liczenie

wypisz:
mov eax, 4
mov ebx, 1
int 0x80
ret

nl:
mov eax, 4
mov ebx, 1
mov ecx, nel
mov edx, nel_len
int 0x80
ret

czyscrejestr:
xor eax, eax
xor ebx, ebx
xor ecx, ecx
xor edx, edx
ret

converHex:
mov al, [edi+1]
cmp al, '0'
jl zla_dana
cmp al, '9'
jle liczba
cmp al, 'A'
jl zla_dana
cmp al, 'F'
jle literaduza
cmp al, 'a'
jl zla_dana
cmp al, 'f'
jle literamala
jmp zla_dana

liczba:
sub al, '0'
jmp store

literaduza:
sub al, 'A' - 10
jmp store

literamala:
sub al, 'a' - 10
jmp store

store:
mov [edi+1], al
inc edi
dec ecx
jnz converHex
ret

zla_dana:
mov eax, 4
mov ebx, 1
mov ecx, msgerr2
mov edx, msg_lenerr2
int 0x80
jmp exit

zly_znak:
mov eax, 4
mov ebx, 1
mov ecx, msgerr1
mov edx, msg_lenerr1
int 0x80
jmp exit

combineHex:
mov al, [esi + edx - 1]
shl al, 4
mov bl, [esi + edx]
or al, bl
mov [edi + 1], al
inc edi
dec edx
dec edx
dec ecx
jnz combineHex
ret

onebyteHex1:
mov [strlen1hex], ecx
mov al, [esi+1]
mov [edi+1], al
jmp znak

onebyteHex:
mov [strlen2hex], ecx
mov al, [esi+1]
mov [edi+1], al
jmp liczenie

liczenie:
mov ecx, dword [ebp + 16]
mov al, [ecx]
cmp al, '+'
je liczsum

mov al, [ecx]
cmp al, '-'
je liczroz

mov al, [ecx]
cmp al, '*'
je liczmnoz

liczsum:
mov eax, [strlen1hex]
mov ebx, [strlen2hex]
cmp eax, ebx
je sumuj
mov eax, [strlen1hex]
mov ebx, [strlen2hex]
cmp eax, ebx
jg sumuj_z_przeniesieniem_wzgledem_Num1
mov eax, [strlen1hex]
mov ebx, [strlen2hex]
cmp eax, ebx
jl sumuj_z_przeniesieniem_wzgledem_Num2

sumuj:
call czyscrejestr
xor esi, esi
xor edi, edi
;przenosimy do tabeli wynik wartosci 1. licby
mov esi, Hex1_arr
mov edi, Wynik_arr
mov ecx, [strlen1hex]
add edi, ecx
call przepisz_odwroc
call czyscrejestr ;zeby pozbyc sie wszystkiego z eax, ebx, ecx i edx
;dostosowujemy drugiego arraya do wynikowego
mov esi, Hex2_arr
mov edi, PrzepisanaLiczba_arr
mov ecx, [strlen1hex]
add edi, ecx
call przepisz_odwroc
call czyscrejestr
xor esi, esi
xor edi, edi
mov esi, Wynik_arr
mov edi, PrzepisanaLiczba_arr
mov ecx, [strlen1hex]
call sumator

sumuj_z_przeniesieniem_wzgledem_Num1:
call czyscrejestr
xor esi, esi
xor edi, edi
;przenosimy do tabeli wynik wartosci 1. licby
mov esi, Hex1_arr
mov edi, Wynik_arr
mov ecx, [strlen1hex]
add edi, ecx
call przepisz_odwroc
call czyscrejestr ;zeby pozbyc sie wszystkiego z eax, ebx, ecx i edx
;dostosowujemy drugiego arraya do wynikowego
mov esi, Hex2_arr
mov edi, PrzepisanaLiczba_arr
mov ecx, [strlen2hex]
add edi, ecx
call roznicastrlen1astrlen2
add edi, ecx
call przepisz_odwroc
call czyscrejestr
xor esi, esi
xor edi, edi
mov esi, Wynik_arr
mov edi, PrzepisanaLiczba_arr
mov ecx, [strlen1hex]
call sumator

sumuj_z_przeniesieniem_wzgledem_Num2:
call czyscrejestr
xor esi, esi
xor edi, edi
;przenosimy do tabeli wynik wartosci 1. licby
mov esi, Hex1_arr
mov edi, Wynik_arr
mov ecx, [strlen1hex]
add edi, ecx
call roznicastrlen2astrlen1
add edi, ecx
call przepisz_odwroc
call czyscrejestr ;zeby pozbyc sie wszystkiego z eax, ebx, ecx i edx
;dostosowujemy drugiego arraya do wynikowego
mov esi, Hex2_arr
mov edi, PrzepisanaLiczba_arr
mov ecx, [strlen2hex]
add edi, ecx
call przepisz_odwroc
call czyscrejestr
xor esi, esi
xor edi, edi
mov esi, Wynik_arr
mov edi, PrzepisanaLiczba_arr
mov ecx, [strlen2hex]
call sumator

sumator:
add esi, ecx
add edi, ecx
mov al, byte [esi]
mov bl, byte [edi]
add al, bl
mov [esi], al
jc add_carry
jmp add_loop

add_carry:
dec esi
mov al, byte [esi]
add al, 1
mov [esi], al
jc add_carry

add_loop:
dec ecx
cmp ecx, 0
je done
dec edi
mov esi, Wynik_arr
add esi, ecx
mov al, byte [esi]
mov bl, byte [edi]
add al, bl
mov [esi], al
jc add_carry
jmp add_loop

liczroz:
mov eax, [strlen1hex]
mov ebx, [strlen2hex]
cmp eax, ebx
je roznica
mov eax, [strlen1hex]
mov ebx, [strlen2hex]
cmp eax, ebx
jg roznica_z_przeniesieniem_wzgledem_Num1
mov eax, [strlen1hex]
mov ebx, [strlen2hex]
cmp eax, ebx
jl roznica_z_przeniesieniem_wzgledem_Num2

roznica:
call czyscrejestr
xor esi, esi
xor edi, edi
;przenosimy do tabeli wynik wartosci 1. licby
mov esi, Hex1_arr
mov edi, Wynik_arr
mov ecx, [strlen1hex]
add edi, ecx
call przepisz_odwroc
call czyscrejestr ;zeby pozbyc sie wszystkiego z eax, ebx, ecx i edx
;dostosowujemy drugiego arraya do wynikowego
mov esi, Hex2_arr
mov edi, PrzepisanaLiczba_arr
mov ecx, [strlen1hex]
add edi, ecx
call przepisz_odwroc
call czyscrejestr
xor esi, esi
xor edi, edi
mov esi, Wynik_arr
mov edi, PrzepisanaLiczba_arr
mov ecx, [strlen1hex]
call roznicor

roznica_z_przeniesieniem_wzgledem_Num1:
call czyscrejestr
xor esi, esi
xor edi, edi
;przenosimy do tabeli wynik wartosci 1. licby
mov esi, Hex1_arr
mov edi, Wynik_arr
mov ecx, [strlen1hex]
add edi, ecx
call przepisz_odwroc
call czyscrejestr ;zeby pozbyc sie wszystkiego z eax, ebx, ecx i edx
;dostosowujemy drugiego arraya do wynikowego
mov esi, Hex2_arr
mov edi, PrzepisanaLiczba_arr
mov ecx, [strlen2hex]
add edi, ecx
call roznicastrlen1astrlen2
add edi, ecx
call przepisz_odwroc
call czyscrejestr
xor esi, esi
xor edi, edi
mov esi, Wynik_arr
mov edi, PrzepisanaLiczba_arr
mov ecx, [strlen1hex]
call roznicor

roznica_z_przeniesieniem_wzgledem_Num2:
call czyscrejestr
xor esi, esi
xor edi, edi
;przenosimy do tabeli wynik wartosci 1. licby
mov esi, Hex1_arr
mov edi, Wynik_arr
mov ecx, [strlen1hex]
add edi, ecx
call roznicastrlen2astrlen1
add edi, ecx
call przepisz_odwroc
call czyscrejestr ;zeby pozbyc sie wszystkiego z eax, ebx, ecx i edx
;dostosowujemy drugiego arraya do wynikowego
mov esi, Hex2_arr
mov edi, PrzepisanaLiczba_arr
mov ecx, [strlen2hex]
add edi, ecx
call przepisz_odwroc
call czyscrejestr
xor esi, esi
xor edi, edi
mov esi, Wynik_arr
mov edi, PrzepisanaLiczba_arr
mov ecx, [strlen2hex]
call roznicor

roznicor:
add esi, ecx
add edi, ecx
mov al, byte [esi]
mov bl, byte [edi]
cmp al, bl
jae sub_nocarry
jmp sub_carry

sub_nocarry:
sub al, bl
not al
mov [esi], al
jmp sub_loop

sub_carry:
sub al, bl
not al
add al, 1
mov [esi], al
jmp sub_carecarry


sub_carecarry:
dec esi
mov al, byte [esi]
sub al, 1
mov [esi], al
jc sub_carry
jmp sub_loop

sub_loop:
dec ecx
cmp ecx, 0
je done
dec edi
mov esi, Wynik_arr
add esi, ecx
mov al, byte [esi]
mov bl, byte [edi]
cmp al, bl
jae sub_nocarry
jmp sub_carry


liczmnoz:
mov edx, 1
call wypisz
call nl
jmp exit


przepisz_odwroc:
mov al, [esi+1]
mov [edi], al
inc esi
dec edi
dec ecx
jnz przepisz_odwroc
ret

roznicastrlen1astrlen2:
mov eax, [strlen1hex]
mov ebx, [strlen2hex]
sub eax, ebx
mov ecx, eax
ret

roznicastrlen2astrlen1:
mov eax, [strlen2hex]
mov ebx, [strlen1hex]
sub eax, ebx
mov ecx, eax
ret

done:
jmp exit


exit:
call czyscrejestr
mov eax, 1
mov ebx, 0
int 0x80

