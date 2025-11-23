org 2000h

niyap_read_file:
    mov ah, 02h
    mov al, 1
    mov ch, 0
    mov dh, 0
    mov dl, 80h
    mov bx, file_buffer
    int 13h

    jc niyerror_call

    xor di, di
    xor si, si

    xor ax, ax
    xor cx, cx
    xor dx, dx
    xor bx, bx

    call find_name_00
    inc di

niyap_lines_loop1:
    call split_back_string

    push si
    push di

    mov di, line
    mov si, clear_command
    mov cx, 5
    repe cmpsb
    je clear_command_execute

    mov di, line
    mov si, print_command
    mov cx, 6
    repe cmpsb
    je print_command_execute

    mov di, line
    mov si, print_var_command
    mov cx, 9
    repe cmpsb
    je print_var_command_execute

    mov di, line
    mov si, var_command
    mov cx, 4
    repe cmpsb
    je var_command_execute

    mov di, line
    mov si, equ_command
    mov cx, 4
    repe cmpsb
    je equ_command_execute

    mov di, line
    mov si, add_command
    mov cx, 4
    repe cmpsb
    je add_command_execute

    mov di, line
    mov si, sub_command
    mov cx, 4
    repe cmpsb
    je sub_command_execute

    mov di, line
    mov si, ror_command
    mov cx, 4
    repe cmpsb
    je ror_command_execute

    mov di, line
    mov si, rol_command
    mov cx, 4
    repe cmpsb
    je rol_command_execute

    mov di, line
    mov si, not_command
    mov cx, 3
    repe cmpsb
    je not_command_execute

    mov di, line
    mov si, and_command
    mov cx, 4
    repe cmpsb
    je and_command_execute

    mov di, line
    mov si, or_command
    mov cx, 3
    repe cmpsb
    je or_command_execute

    mov di, line
    mov si, xor_command
    mov cx, 4
    repe cmpsb
    je xor_command_execute

    mov di, line
    mov si, entry_command
    mov cx, 5
    repe cmpsb
    je entry_command_execute

    mov di, line
    mov si, toentry_command
    mov cx, 7
    repe cmpsb
    je toentry_command_execute

    mov di, line
    mov si, entry_flag_command
    mov cx, 8
    repe cmpsb
    je entry_flag_command_execute

    mov di, line
    mov si, exit_command
    mov cx, 4
    repe cmpsb
    je exit_command_execute
niyap_lines_loop2:
    pop di
    pop si

    mov cx, 20
    mov bx, 20
niyap_lines_loop_clear_buffers:
    mov [line+bx], 00h
    mov [args+bx], 00h

    dec bx
    loop niyap_lines_loop_clear_buffers

    cmp [file_buffer+di], 00h
    je $

    jmp niyap_lines_loop1

clear_command_execute:
    mov ax, 0003h
    int 10h

    mov dh, 00h

    jmp niyap_lines_loop2

print_command_execute:
    push si
    push di

    call split_string

    pop di
    pop si

    mov bp, args             
    mov cx, 20
    mov bl, 0Fh
    mov ax, 1301h
    int 10h

    jmp niyap_lines_loop2

print_var_command_execute:
    mov bx, var_carret
    mov ah, 0eh
    mov al, [vars_buffer+bx]
    int 10h

    jmp niyap_lines_loop2

var_command_execute:
    push si
    push di

    call split_string
    call atoi

    pop di
    pop si

    mov [var_carret], al

    jmp niyap_lines_loop2

equ_command_execute:
    push si
    push di

    call split_string
    call atoi

    mov si, var_carret
    mov [vars_buffer+si], al

    pop di
    pop si

    jmp niyap_lines_loop2

add_command_execute:
    push si
    push di

    call split_string
    call atoi

    mov si, var_carret
    mov dl, [vars_buffer+si]
    add dl, al
    mov [vars_buffer+si], dl

    pop di
    pop si

    jmp niyap_lines_loop2

sub_command_execute:
    push si
    push di

    call split_string
    call atoi

    mov si, var_carret
    sub [vars_buffer+si], al

    pop di
    pop si

    jmp niyap_lines_loop2

ror_command_execute:
    push si
    push di

    call split_string
    call atoi

    mov si, var_carret
    mov cl, al
    ror [vars_buffer+si], cl

    pop di
    pop si

    jmp niyap_lines_loop2

rol_command_execute:
    push si
    push di

    call split_string
    call atoi

    mov si, var_carret
    mov cl, al
    rol [vars_buffer+si], cl

    pop di
    pop si

    jmp niyap_lines_loop2

not_command_execute:
    mov bx, var_carret
    not [vars_buffer+bx]

    jmp niyap_lines_loop2

and_command_execute:
    push si
    push di

    call split_string
    call atoi

    mov si, var_carret
    and [vars_buffer+si], al

    pop di
    pop si

    jmp niyap_lines_loop2

or_command_execute:
    push si
    push di

    call split_string
    call atoi

    mov si, var_carret
    or [vars_buffer+si], al

    pop di
    pop si

    jmp niyap_lines_loop2

xor_command_execute:
    push si
    push di

    call split_string
    call atoi

    mov si, var_carret
    xor [vars_buffer+si], al

    pop di
    pop si

    jmp niyap_lines_loop2

entry_command_execute:
    mov ax, di
    dec ah
    mov [entry_point], ah

    jmp niyap_lines_loop2

toentry_command_execute:
    pop di
    pop si

    mov cx, 20
    mov bx, 20

    sub [entry_loop_flag], 1

    cmp [entry_loop_flag], 00h
    je niyap_lines_loop_clear_buffers

    mov ax, 00h
    mov al, [entry_point]

    mov di, ax

    jmp niyap_lines_loop_clear_buffers

entry_flag_command_execute:
    push si
    push di

    call split_string
    call atoi

    mov [entry_loop_flag], al

    pop di
    pop si

    jmp niyap_lines_loop2

exit_command_execute:
    mov ah, 10h
    int 16h

    mov ah, 02h
    mov al, 1
    mov ch, 0
    mov cl, 2
    mov dh, 0
    mov dl, 80h
    mov bx, 500h
    int 13h

    jc niyerror_call

    xor ax, ax
    xor cx, cx
    xor dx, dx
    xor bx, bx

    jmp 0000:0500h

find_name_00:
    cmp [file_buffer+di], 00h
    je find_name_00_end

    inc di

    jmp find_name_00
find_name_00_end:
    ret

split_back_string:
    mov si, 00h
split_back_string_loop:
    mov al, [file_buffer+di]

    cmp al, ';'
    je split_back_string_end

    cmp al, 0afh
    je new_line_replace

    mov [line+si], al

    inc di
    inc si

    jmp split_back_string_loop
new_line_replace:
    inc di

    jmp split_back_string_loop
split_back_string_end:
    inc di
    ret

split_string:
    mov si, 0
split_string_loop1:
    cmp [line+si], ' '
    je split_string_loop2_pre

    inc si

    jmp split_string_loop1
split_string_loop2_pre:
    mov cx, si
    inc cx
    mov si, 0
split_string_loop2:
    mov di, si
    add di, cx
    mov dl, [line+di]
    mov [args+si], dl

    cmp dl, 0
    je split_string_end

    inc si
    jmp split_string_loop2
split_string_end:
    ret

atoi:
    mov si, 00h
    mov al, 00h
    mov cl, 00h
    mov bl, 00h
atoi_loop:
    mov cl, [args+si]
    test cl, cl
    je atoi_done

    cmp cl, 48
    jl atoi_done

    cmp cl, 57
    jg atoi_done

    sub cl, 48
    mov bl, 10
    mul bl
    add al, cl

    inc si
    jmp atoi_loop
atoi_done:
    ret

niyerror_call:
    push ax

    mov ah, 02h
    mov al, 1
    mov ch, 0
    mov cl, 7
    mov dh, 0
    mov dl, 80h
    mov bx, 1500h
    int 13h

    pop ax

    xor bx, bx

    jmp 0000:1500h

file_buffer_poin db 0
line db 20 dup(0)
args db 20 dup(0)

print_command db 'print '
print_var_command db 'print.var'
clear_command db 'clear'

var_command db 'var '
equ_command db 'equ '

add_command db 'add '
sub_command db 'sub '

ror_command db 'ror '
rol_command db 'rol '

not_command db 'not'
and_command db 'and '
or_command db 'or '
xor_command db 'xor '

exit_command db 'exit'

entry_flag_command db 'entflag '
entry_command db 'entry'
toentry_command db 'toentry'

entry_point db 0
toentry_point db 0
entry_loop_flag db 0

vars_buffer db 20 dup(0)
var_carret db 0fh

file_buffer db 512 dup(2)
times(1536-($-02000h)) db 1