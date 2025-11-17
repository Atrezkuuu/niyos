org 7c00h

start:
    cli
    xor ax, ax
    mov ds, ax
    mov [boot_drive], dl
    mov es, ax
    mov ss, ax
    mov sp, 7c00h
    sti

    mov ax, 0003h
    int 10h

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
    mov al, 0cch

    mov ax, 0003h
    int 10h

    mov cx, -1
    push cx

    jmp clear_input

fs_command_execute:
    call split_string

    mov ah, 02h
    mov al, 2
    mov ch, 0
    mov cl, 2
    mov dh, 0
    mov dl, [boot_drive]
    mov bx, 1000h
    int 13h

    push cx

    xor ax, ax
    xor cx, cx
    xor dx, dx
    xor bx, bx

    mov ah, 0bh
    jmp 0000:1000h

mk_command_execute:
    call split_string

    mov ah, 02h
    mov al, 2
    mov ch, 0
    mov cl, 2
    mov dh, 0
    mov dl, [boot_drive]
    mov bx, 1000h
    int 13h

    push cx

    xor ax, ax
    xor cx, cx
    xor dx, dx
    xor bx, bx

    mov di, args
    mov ah, 0ch
    jmp 0000:1000h

write_command_execute:
    call split_string

    mov ah, 02h
    mov al, 2
    mov ch, 0
    mov cl, 2
    mov dh, 0
    mov dl, [boot_drive]
    mov bx, 1000h
    int 13h

    push cx

    xor ax, ax
    xor cx, cx
    xor dx, dx
    xor bx, bx

    mov di, args
    mov ah, 0dh
    jmp 0000:1000h

delete_command_execute:
    call split_string

    mov ah, 02h
    mov al, 2
    mov ch, 0
    mov cl, 2
    mov dh, 0
    mov dl, [boot_drive]
    mov bx, 1000h
    int 13h

    push cx

    xor ax, ax
    xor cx, cx
    xor dx, dx
    xor bx, bx

    mov di, args
    mov ah, 0ah
    jmp 0000:1000h

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

cl_command db 'cl', 0
fs_command db 'fs', 0
mk_command db 'mk '
write_command db 'write '
delete_command db 'del '
boot_drive db 0

input db 21 dup(0)
args db 10 dup(0)

times(512-2-($-07c00h)) db 0
db 055h, 0AAh