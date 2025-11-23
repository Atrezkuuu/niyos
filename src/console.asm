org 500h

start:
    cmp ah, 0a1h
    je console_loop

    jmp cl_command_execute

console_loop:
    mov ah, 02h
    mov dh, cl
    mov dl, 00h
    int 10h

    mov ah, 0eh
    mov al, '&'
    int 10h

    mov ah, 0eh
    mov al, '>'
    int 10h

console_keyboard_loop1:
    mov ah, 10h
    int 16h

    cmp ah, 0eh
    jz del_sim

    cmp al, 0dh
    jz command_exec

    cmp si, 20
    jge console_keyboard_loop1

    mov [input+si], al
    inc si

console_keyboard_loop2:
    mov ah, 02h
    mov dh, cl
    mov dl, 03h
    int 10h

    push cx
    mov bp, input             
    mov cx, 20
    mov bl, 0Fh
    mov ax, 1301h
    int 10h
    pop cx

    jmp console_keyboard_loop1

del_sim:
    cmp si, 0
    je console_keyboard_loop1

    dec si
    mov [input+si], 0
    jmp console_keyboard_loop2

command_exec:
    push cx
    push si

    mov di, input
    mov si, cl_command
    mov cx, 3
    repe cmpsb
    je cl_command_execute

    mov di, input
    mov si, shutdown_command
    mov cx, 4
    repe cmpsb
    je shutdown_command_execute

    mov di, input
    mov si, reboot_command
    mov cx, 4
    repe cmpsb
    je reboot_command_execute

    mov di, input
    mov si, fs_command
    mov cx, 3
    repe cmpsb
    je fs_command_execute

    mov di, input
    mov si, mk_command
    mov cx, 3
    repe cmpsb
    je mk_command_execute

    mov di, input
    mov si, write_command
    mov cx, 6
    repe cmpsb
    je write_command_execute

    mov di, input
    mov si, delete_command
    mov cx, 4
    repe cmpsb
    je delete_command_execute

    mov di, input
    mov si, exec_command
    mov cx, 3
    repe cmpsb
    je exec_command_execute

    pop si

clear_input:
    mov si, 20
    mov cx, 20
clear_input_loop:
    cmp si, 0
    je end_clear_input_loop

    dec si
    mov [input+si], 0

    loop clear_input_loop
end_clear_input_loop:
    pop cx

    inc cl

    jmp console_loop

cl_command_execute:
    mov ax, 0003h
    int 10h

    mov cx, -1
    push cx

    jmp clear_input

shutdown_command_execute:
    push ax

    mov ax, 5301h
    xor bx, bx
    int 15h

    mov ax, 530eh
    xor bx, bx
    mov cx, 102h
    int 15h

    mov ax, 5307h
    mov bx, 01h
    mov cx, 03h
    int 15h

    pop ax

    mov ah, 0e0h
    jmp niyerror_call

reboot_command_execute:
    cli
    mov al, 0FEh
    out 64h, al

    mov ah, 0e1h
    jmp niyerror_call

fs_command_execute:
    call split_string

    mov ah, 02h
    mov al, 3
    mov ch, 0
    mov cl, 4
    mov dh, 0
    mov dl, 80h
    mov bx, 1500h
    int 13h

    jc niyerror_call

    push cx

    xor ax, ax
    xor cx, cx
    xor dx, dx
    xor bx, bx

    mov ah, 0bh
    jmp 0000:1500h

mk_command_execute:
    call split_string

    mov ah, 02h
    mov al, 3
    mov ch, 0
    mov cl, 4
    mov dh, 0
    mov dl, 80h
    mov bx, 1500h
    int 13h

    jc niyerror_call

    push cx

    xor ax, ax
    xor cx, cx
    xor dx, dx
    xor bx, bx

    mov di, args
    mov ah, 0ch
    jmp 0000:1500h

write_command_execute:
    call split_string

    mov ah, 02h
    mov al, 3
    mov ch, 0
    mov cl, 4
    mov dh, 0
    mov dl, 80h
    mov bx, 1500h
    int 13h

    jc niyerror_call

    push cx

    xor ax, ax
    xor cx, cx
    xor dx, dx
    xor bx, bx

    mov di, args
    mov ah, 0dh
    jmp 0000:1500h

delete_command_execute:
    call split_string

    mov ah, 02h
    mov al, 3
    mov ch, 0
    mov cl, 4
    mov dh, 0
    mov dl, 80h
    mov bx, 1500h
    int 13h

    jc niyerror_call

    push cx

    xor ax, ax
    xor cx, cx
    xor dx, dx
    xor bx, bx

    mov di, args
    mov ah, 0ah
    jmp 0000:1500h

exec_command_execute:
    call split_string

    mov ah, 02h
    mov al, 3
    mov ch, 0
    mov cl, 4
    mov dh, 0
    mov dl, 80h
    mov bx, 1500h
    int 13h

    jc niyerror_call

    xor ax, ax
    xor cx, cx
    xor dx, dx
    xor bx, bx

    mov di, args
    mov ah, 1ah
    jmp 0000:1500h

split_string:
    mov si, 0
split_string_loop1:
    cmp [input+si], ' '
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
    mov dl, [input+di]
    mov [args+si], dl

    cmp dl, 0
    je split_string_end

    inc si
    jmp split_string_loop2
split_string_end:
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

shutdown_command db 'shd', 0
reboot_command db 'rbt', 0
cl_command db 'cl', 0
fs_command db 'fs', 0
mk_command db 'mk '
write_command db 'write '
delete_command db 'del '
exec_command db 'exec '

input db 21 dup(0)
args db 10 dup(0)

times(1024-($-0500h)) db 1