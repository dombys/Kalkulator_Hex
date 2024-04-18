section .data
newline db 0xa
newline_len equ $ -newline

msgdziel db 'Dziele', 0xa
msg_lendziel equ $ -msgdziel

msgerr1 db 'Podano zly znak', 0xa
msg_lenerr1 equ $ -msgerr1

msgerr2 db 'Podano zla dana, sprawdz podane argumenty', 0xa
msg_lenerr2 equ $ -msgerr2

err_msg db 'Podano 0 jako argument. Nie dzelimy przez 0', 0xa
err_msg_len equ $ -err_msg

msg_dziel_short db 'Wynik dzielenia: ', 0xa
msg_dziel_short_len equ $ -msg_dziel_short

msg_dziel_reszta db 'Reszta dzielenia: ', 0xa
msg_dziel_reszta_len equ $ -msg_dziel_reszta

msg_dziel_dzielnik db 'Podano za długi dzielnik (kalkulator obsługuje max 4 bajtowy hexadecymalny dzielnik - 8 znaków)', 0xa
msg_dziel_dzielnik_len equ $ -msg_dziel_dzielnik

msg_zero db '0', 0xa
msg_zero_len equ $ -msg_zero

nel db 0xa
nel_len equ $ -nel

strlen1 times 8 db 0
strlen2 times 8 db 0
carr times 2 db 0
petl times 2 db 0
reszt times 8 db 0
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

mov al, [ecx]
cmp al, '/'
je dziel
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

dziel:
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

mov al, [ecx]
cmp al, '/'
je liczdziel

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
call sumator

sumuj_z_przeniesieniem_wzgledem_Num1:
;liczba Num1 jest dłuższa od Num2, wiec po przepisaniu do Wynik_arr musimy dostosować jeszcze drugi array
mov esi, Num1_arr
mov edi, Wynik_arr
mov ecx, [strlen1]
call przepisz
call czyscrejestr
mov esi, Num2_arr
mov edi, PrzepisanaLiczba_arr
call roznicastrlen1astrlen2
add edi, ecx
mov ecx, [strlen2]
call przepisz
call czyscrejestr
mov esi, Wynik_arr
mov edi, PrzepisanaLiczba_arr
mov ecx, [strlen1]
call sumator

sumuj_z_przeniesieniem_wzgledem_Num2:
;liczba Num2 jest dłuższa od Num1, wiec po przepisaniu do Wynik_arr musimy dostosować jeszcze drugi array
mov esi, Num1_arr
mov edi, Wynik_arr
call roznicastrlen2astrlen1
add edi, ecx
mov ecx, [strlen1]
call przepisz
call czyscrejestr
mov esi, Num2_arr
mov edi, PrzepisanaLiczba_arr
mov ecx, [strlen2]
call przepisz
call czyscrejestr
mov esi, Wynik_arr
mov edi, PrzepisanaLiczba_arr
mov ecx, [strlen2]
call sumator


sumator:
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
mov esi, Num1_arr
mov edi, Wynik_arr
mov ecx, [strlen1]
call przepisz
call czyscrejestr
mov esi, Wynik_arr
mov edi, Num2_arr
mov ecx, [strlen1]
call roznicuj

roznica_z_przeniesieniem_wzgledem_Num1:
mov esi, Num1_arr
mov edi, Wynik_arr
mov ecx, [strlen1]
call przepisz
call czyscrejestr
mov esi, Num2_arr
mov edi, PrzepisanaLiczba_arr
call roznicastrlen1astrlen2
add edi, ecx
mov ecx, [strlen2]
call przepisz
call czyscrejestr
mov esi, Wynik_arr
mov edi, PrzepisanaLiczba_arr
mov ecx, [strlen1]
call roznicuj

roznica_z_przeniesieniem_wzgledem_Num2:
mov esi, Num1_arr
mov edi, Wynik_arr
call roznicastrlen2astrlen1
add edi, ecx
mov ecx, [strlen1]
call przepisz
call czyscrejestr
mov esi, Num2_arr
mov edi, PrzepisanaLiczba_arr
mov ecx, [strlen2]
call przepisz
call czyscrejestr
mov esi, Wynik_arr
mov edi, PrzepisanaLiczba_arr
mov ecx, [strlen2]
call roznicuj

roznicuj:
add esi, ecx
add edi, ecx
mov al, [esi]
mov bl, [edi]
cmp al, bl
jl sub_with_borrow
sub al, bl
mov [esi], al
jmp sub_loop

sub_with_borrow:
add al, 0x10
sub al, bl
mov [esi], al
jmp sub_carry

sub_carry:
cmp esi, 0
je done
dec esi
mov al, [esi]
cmp al, 0x00
je change_F
sub al, 0x01
mov [esi], al
jmp sub_loop

change_F:
mov al, 0x0F
mov [esi], al
jmp sub_carry

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
jl sub_with_borrow
sub al, bl
mov [esi], al
jmp sub_loop

liczmnoz:
;zaczynamy od sprawdzenia co dłuższe - od tego determinujemy ecx przy mnożeniu
mov eax, [strlen1]
mov ebx, [strlen2]
cmp eax, ebx
jge mnoz_strlen1
jmp mnoz_strlen2


mnoz_strlen1:
mov esi, Num1_arr
mov edi, Num2_arr
mov ecx, [strlen1]
add esi, ecx
mov ecx, [strlen2]
add edi, ecx
mov ecx, [strlen1]
mov al, byte [esi]
mov bl, byte [edi]
mul bl
mov edi, 0
call podlicz_petl
mov edi, Wynik_arr
add edi, ecx
add edi, 1
cmp al, 0x10
jge sprawdz_carry
mov [edi], al
jmp mul_loop_One

podlicz_petl:
inc edi
mov [petl], edi
ret

mul_loop_One:
dec ecx
cmp ecx, 0
je done_mul
dec esi
dec edi
mov al, byte [esi]
mul bl
mov dl, [carr]
add al, dl
xor edx, edx
cmp al, 0x10
jge sprawdz_carry
mov [edi], al
cmp al, 0x10
jl clear_carr
jmp mul_loop_One

clear_carr:
xor edx, edx
mov edx, 0
mov [carr], edx
jmp mul_loop_One

done_mul:
dec edi
mov dl, [carr]
mov [edi], dl
jmp wypisz_mul

sprawdz_carry:
cmp al, 0x10
jl carr_wpis
inc edx
sub al, 0x10
cmp al, 0x10
jge sprawdz_carry
carr_wpis:
mov [carr], edx
mov [edi], al
jmp mul_loop_One

mnoz_strlen2:
mov esi, Num1_arr
mov edi, Num2_arr
mov edx, Wynik_arr
mov ecx, [strlen2]
add edi, ecx
add edx, ecx
mov ecx, [strlen1]
add edx, ecx
; poniewaz przy mnozeniu moga byc 2 przeniesienia -> jedno na ostatnim bajcie przy dodawaniu, drugie jako wynik ostatniego dodawania
mov ecx, [strlen1]
add esi, ecx
jmp exit
; nie przygotowano wariantu, w którym A jest krótsze od B

liczdziel:

dlugosc_dzielnika:
mov ecx, [strlen2]
cmp ecx, 8
ja dlugi_dzielnik
jmp sprawdz_zero

dlugi_dzielnik:
mov ecx, msg_dziel_dzielnik
mov edx, msg_dziel_dzielnik_len
call wypisz
jmp exit

sprawdz_zero:
mov eax, [Num2_arr]
cmp eax, 0
je err_msgpisz
jmp test_strlena

err_msgpisz:
mov ecx, err_msg
mov edx, err_msg_len
call wypisz
jmp exit

test_strlena:
mov eax, [strlen1]
mov ebx, [strlen2]
cmp eax, ebx
jb msgnr2
jmp okresl_dzielnik

msgnr2:
mov ecx, msg_dziel_short
mov edx, msg_dziel_short_len
call wypisz
mov ecx, msg_zero
mov edx, msg_zero_len
call wypisz
mov ecx, msg_dziel_reszta
mov edx, msg_dziel_reszta_len
call wypisz
mov ecx, [ebp + 12]
mov edx, [strlen1]
call wypisz
call nl
jmp exit

okresl_dzielnik:
call czyscrejestr
mov esi, Num2_arr
inc esi ;by ominac pierwsze 0
mov ecx, [strlen2]
cmp ecx, 2
jbe dzielnik_one_byte
cmp ecx, 4
jbe dzielnik_two_byte
cmp ecx, 6
jbe dzielnik_three_byte
cmp ecx, 8
jbe dzielnik_four_byte

dzielnik_one_byte:
mov bl, [esi]
dec ecx
jz wpisz_first_byte
inc esi
shl bl, 4
add bl, [esi]
jmp wpisz_first_byte

dzielnik_two_byte:
mov bl, [esi]
dec ecx ;ecx 3
inc esi 
shl bl, 4
add bl, [esi]
dec ecx ;ecx 2
inc esi
shl bx, 4
add bl, [esi]
dec ecx ;ecx 1 lub 0
jz wpisz_first_byte
inc esi
shl bx, 4
add bl, [esi]
jmp wpisz_first_byte

dzielnik_three_byte:
mov bl, [esi]
dec ecx ;ecx 5
inc esi 
shl bl, 4
add bl, [esi]
dec ecx ;ecx 4
inc esi
shl bx, 4
add bl, [esi]
dec ecx ;ecx 3
inc esi
shl bx, 4
add bl, [esi]
dec ecx ;ecx 2
inc esi
shl ebx, 4
add bl, [esi]
dec ecx ;ecx 1/0
jz wpisz_first_byte
inc esi
shl ebx, 4
add bl, [esi]
jmp wpisz_first_byte

dzielnik_four_byte:
mov bl, [esi]
dec ecx ;ecx 5
inc esi 
shl bl, 4
add bl, [esi]
dec ecx ;ecx 4
inc esi
shl bx, 4
add bl, [esi]
dec ecx ;ecx 3
inc esi
shl bx, 4
add bl, [esi]
dec ecx ;ecx 2
inc esi
shl ebx, 4
add bl, [esi]
dec ecx ;ecx 1/0
inc esi
shl ebx, 4
add bl, [esi]
dec ecx ;ecx 1/0
inc esi
shl ebx, 4
add bl, [esi]
dec ecx
jz wpisz_first_byte
inc esi
shl ebx, 4
add bl, [esi]
jmp wpisz_first_byte

wpisz_first_byte:
mov ecx, [strlen1]
mov edi, Wynik_arr
mov esi, Num1_arr
add esi, 1
mov eax, [esi]

dzielim:
div ebx
mov [edi], eax
mov [reszt], edx

dalej:
dec ecx
cmp ecx, 0
je done_dziel
inc edi
inc esi
xor eax, eax
xor edx, edx
wpisz_next:
mov edx, [reszt]
cmp edx, 0
je bez_reszty
mov al, dl
shl eax, 4
mov al, [esi]
cmp eax, ebx
jb z_reszta
jmp dzielim

bez_reszty:
mov al, [esi]
cmp eax, ebx
jae dzielim
dec ecx
cmp ecx, 0
je done_dziel
inc esi
inc edi
shl eax, 4
jmp bez_reszty

z_reszta:
dec ecx
cmp ecx, 0
je done_dziel
inc esi
inc edi
shl eax, 4
mov al, [esi]
cmp eax, ebx
jb z_reszta
jmp dzielim

done_dziel:
mov edi, Wynik_arr
mov ecx, [strlen1]
call converback
mov ecx, msg_dziel_short
mov edx, msg_dziel_short_len
call wypisz
mov ecx, Wynik_arr
mov edx, [strlen1]
call wypisz
call nl
mov ecx, [reszt]
cmp ecx, 0
je exit
mov ecx, msg_dziel_reszta
mov edx, msg_dziel_reszta_len
call wypisz
mov edi, reszt
mov ecx, [strlen1]
call converback

odwroc:
mov edi, reszt
mov esi, Wypisz_arr
add esi, [strlen1]
mov ecx, [strlen1]
przepisujemy:
mov al, [edi]
mov [esi], al
dec ecx
cmp ecx, 0
je wypisywanie
inc esi
inc edi
jmp przepisujemy

wypisywanie:
mov ecx, Wypisz_arr
mov edx, [strlen1]
add edx, 1
call wypisz
call nl
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

converback:
mov al, [edi]
cmp al, 0x09
jle liczbaASCII
cmp al, 0x0F
jle literaASCII

liczbaASCII:
add al, '0'
jmp storeASCII

literaASCII:
add al, 'A' - 10
jmp storeASCII

storeASCII:
mov [edi], al
inc edi
dec ecx
jnz converback
ret


done:
call czyscrejestr
mov edi, Wynik_arr
mov eax, [strlen1]
mov ebx, [strlen2]
cmp eax, ebx
jge strlen1dl
mov ecx, [strlen2]
add ecx, 1
call converback
call nl
mov ecx, Wynik_arr
mov edx, [strlen2]
add edx, 1
call wypisz
call nl
jmp exit

strlen1dl:
mov ecx, [strlen1]
add ecx, 1
call converback
call nl
mov ecx, Wynik_arr
mov edx, [strlen1]
add edx, 1
call wypisz
call nl
jmp exit


wypisz_mul:
call czyscrejestr
mov edi, Wynik_arr
mov eax, [strlen1]
mov ebx, [strlen2]
mov ecx, 0
add ecx, eax
add ecx, ebx
add ecx, 1
call converback
call nl
mov ecx, Wynik_arr
mov eax, [strlen1]
mov ebx, [strlen2]
mov edx, 0
add edx, eax
add edx, ebx
add edx, 1
call wypisz
call nl
jmp exit

exit:
call czyscrejestr
mov eax, 1
mov ebx, 0
int 0x80

