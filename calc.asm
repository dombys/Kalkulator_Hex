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
Num1_arr times 200 db 0
Num2_arr times 200 db 0
Hex1_arr times 100 db 0
Hex2_arr times 100 db 0
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
mov [edi], al
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
mov eax, [strlen1]
and eax, 1
mov ecx, [strlen1]
add ecx, eax
shr ecx, 1
call combineHex

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
mov eax, 4
mov ebx, 1
mov edx, 1
int 0x80
call nl
jmp num2

odejmij:
mov eax, 4
mov ebx, 1
mov edx, 1
int 0x80
call nl
jmp num2

mnoz:
mov eax, 4
mov ebx, 1
mov edx, 1
int 0x80
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
mov [edi], al
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
mov eax, [strlen2]
and eax, 1
mov ecx, [strlen2]
add ecx, eax
shr ecx, 1
call combineHex
jmp exit

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
mov al, [edi]
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
mov [edi], al
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
mov al, [esi]
shl al, 4
mov bl, [esi+1]
or al, bl
mov [edi], al
inc esi
inc esi
inc edi
dec ecx
jnz combineHex
ret

exit:
mov eax, 1
mov ebx, 0
int 0x80

