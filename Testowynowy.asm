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
przeniesieniedanych times 8 db 0
Num1_arr times 201 db 0
Num2_arr times 201 db 0
PrzepisanaLiczba_arr times 201 db 0
Wynik_arr times 2002 db 0
Wypisz_arr times 2002 db 0

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
mov eax, [strlen1]
mov ebx, [strlen2]
cmp eax, ebx
je sumuj
mov eax, [strlen1]
mov ebx, [strlen2]
cmp eax, ebx
jg sumuj_z_przeniesieniem_wzgledem_Num1
mov eax, [strlen1]
mov ebx, [strlen2]
cmp eax, ebx
jl sumuj_z_przeniesieniem_wzgledem_Num2

sumuj:
;liczby równej dłuości, więc przepisujemy stringa do stringa wynikowego bez zmian w drugim
mov esi, Num1_arr
mov edi, Wynik_arr
mov ecx, [strlen1]
call przepisz
call czyscrejestr
mov esi, Wynik_arr
mov edi, Num2_arr
mov ecx, [strlen1]
add esi, ecx
add edi, ecx
mov al, [esi]
mov bl, [edi]
add al, bl
cmp al, 0x10
jge do_reszty
mov [esi], al
jmp add_loop

do_reszty:
sub al, 0x10
mov [esi], al
jmp is_carry

is_carry:
cmp esi, 0
je last_add
dec esi
mov al, [esi]
cmp al, 0x0F
je change_zero
add al, 0x01
mov [esi], al
jmp add_loop

change_zero:
mov al, 0
mov [esi], al
jmp is_carry

last_add:
mov al, 1
mov [esi], al
jmp add_loop

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
cmp al, 0x10
jge do_reszty
mov [esi], al
jmp add_loop



sumuj_z_przeniesieniem_wzgledem_Num1:
jmp exit

sumuj_z_przeniesieniem_wzgledem_Num2:
jmp exit

liczroz:
mov eax, [strlen1]
mov ebx, [strlen2]
cmp eax, ebx
je roznica
mov eax, [strlen1]
mov ebx, [strlen2]
cmp eax, ebx
jg roznica_z_przeniesieniem_wzgledem_Num1
mov eax, [strlen1]
mov ebx, [strlen2]
cmp eax, ebx
jl roznica_z_przeniesieniem_wzgledem_Num2

roznica:
jmp exit

roznica_z_przeniesieniem_wzgledem_Num1:
jmp exit

roznica_z_przeniesieniem_wzgledem_Num2:
jmp exit


liczmnoz:
jmp exit


przepisz:
mov al, [esi+1]
mov [edi+1], al
inc esi
inc edi
dec ecx
jnz przepisz
ret

roznicastrlen1astrlen2:
mov eax, [strlen1]
mov ebx, [strlen2]
sub eax, ebx
mov ecx, eax
ret

roznicastrlen2astrlen1:
mov eax, [strlen2]
mov ebx, [strlen1]
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

