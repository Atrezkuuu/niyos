org 7c00h

start:
    cli
    xor ax, ax
    mov ds, ax
    mov [boot_drive], dl
    mov es, ax
    mov ss, ax
    mov sp, 07c00h
    sti

mes_draw:
    mov ax, 0003h
    int 10h

    mov ah, 02h
    mov dx, 00h
    int 10h

    mov bp, load_message             
    mov cx, 16
    mov bl, 0Fh
    mov ax, 1301h
    int 10h

    mov ah, 02h
    mov dx, 0100h
    int 10h

    mov bp, install_message1             
    mov cx, 29
    mov bl, 0Fh
    mov ax, 1301h
    int 10h

    mov ah, 02h
    mov dx, 011Ch
    int 10h

    mov bp, install_message2             
    mov cx, 21
    mov bl, 0Ch
    mov ax, 1301h
    int 10h

    mov ah, 02h
    mov dx, 1800h
    int 10h

    mov bp, install_message3             
    mov cx, 17
    mov bl, 0Fh
    mov ax, 1301h
    int 10h

    mov ah, 02h
    mov dx, 0200h
    int 10h

input_loop1:
    mov ah, 10h
    int 16h

    cmp ah, 0eh
    jz del_sim

    cmp al, 0dh
    jz command_exec

    cmp si, 3
    jge input_loop1

    mov [input+si], al
    inc si

input_loop2:
    mov bp, input             
    mov cx, 3
    mov bl, 0Fh
    mov ax, 1301h
    int 10h

    jmp input_loop1

del_sim:
    cmp si, 0
    je input_loop1

    dec si
    mov [input+si], 0
    jmp input_loop2

command_exec:
    mov di, input
    push si
    mov si, no_command
    mov cx, 3
    repe cmpsb
    je no_command_exec
    pop si

    mov di, input
    push si
    mov si, yes_command
    mov cx, 3
    repe cmpsb
    je yes_command_exec
    pop si

    jmp input_loop1

no_command_exec:
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

yes_command_exec:
    mov ah, 00h
    int 13h

    mov ax, 0000h
    mov es, ax

    mov ah, 02h
    mov al, 2
    mov ch, 0
    mov cl, 2
    mov dh, 0
    mov dl, [boot_drive]
    mov bx, 500h
    int 13h

    xor dx, dx
    xor bx, bx

    jmp 0000:0500h

boot_drive db 0

load_message db 'NIYOS bootloader', 0
install_message1 db 'Do you want to install NIYOS', 0
install_message2 db ' DISK WILL BE ERASED!', 0
install_message3 db 'Type yes or no...', 0

no_command db 'no', 0
yes_command db 'yes', 0

input db 3 dup(0)

times(512-2-($-07C00h)) db 0
db 055h, 0AAh