global welcome
section .text

welcome:
enter 0,0

mov esi, [ebp+8] ;tablica 1
mov edi, [ebp+12] ;tablica 2
mov ecx, [ebp+16] ;ile liczb


testowa:
.sumator:
add esi, ecx
add edi, ecx
mov al, byte [esi]
;mov bl, byte [edi]
add al, byte [edi] ;było bl
cmp al, 0x10
jge .do_reszty
mov [esi], al
jmp .add_loop

.do_reszty:
sub al, 0x10
mov [esi], al
jmp .is_carry

.is_carry:
cmp esi, 0
je .last_add
dec esi
mov al, [esi]
cmp al, 0x0F
je .change_zero
add al, 0x01
mov [esi], al
jmp .add_loop

.change_zero:
mov al, 0
mov [esi], al
jmp .is_carry

.last_add:
mov al, 1
mov [esi], al
jmp .add_loop

.add_loop:
dec ecx
cmp ecx, 0
je .done
dec edi
mov esi, [ebp + 8]
add esi, ecx
mov al, byte [esi]
;mov bl, byte [edi]
add al, byte [edi] ;było ebx
cmp al, 0x10
jge .do_reszty
mov [esi], al
jmp .add_loop

.done:
leave
ret
