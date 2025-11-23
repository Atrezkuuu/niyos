org 500h

start:
    mov ax, 0003h
    int 10h

    mov bp, load_message             
    mov cx, 19
    mov bl, 0Fh
    mov ax, 1301h
    int 10h

    mov ah, 02h
    mov dx, 0100h
    int 10h

    mov bp, hddboot_install_message             
    mov cx, 18
    mov bl, 0Fh
    mov ax, 1301h
    int 10h

    mov ah, 02h
    mov al, 1
    mov ch, 0
    mov cl, 4
    mov dh, 0
    mov dl, 80h
    mov bx, 7c00h
    int 13h

    mov ah, 03h
    mov al, 1
    mov ch, 0
    mov cl, 1
    mov dh, 0
    mov dl, 81h
    int 13h

    xor bx, bx

    mov ah, 02h
    mov dx, 0100h
    int 10h

    mov bp, hddboot_install_message             
    mov cx, 18
    mov bl, 0Ah
    mov ax, 1301h
    int 10h

    mov ah, 02h
    mov dx, 0200h
    int 10h

    mov bp, niyfs_install_message             
    mov cx, 16
    mov bl, 0Fh
    mov ax, 1301h
    int 10h

    mov ah, 02h
    mov al, 3
    mov ch, 0
    mov cl, 7
    mov dh, 0
    mov dl, 80h
    mov bx, 1000h
    int 13h

    mov ah, 03h
    mov al, 3
    mov ch, 0
    mov cl, 4
    mov dh, 0
    mov dl, 81h
    int 13h

    xor bx, bx

    mov ah, 02h
    mov dx, 0200h
    int 10h

    mov bp, niyfs_install_message             
    mov cx, 16
    mov bl, 0Ah
    mov ax, 1301h
    int 10h

    mov ah, 02h
    mov dx, 0300h
    int 10h

    mov bp, console_install_message             
    mov cx, 18
    mov bl, 0Fh
    mov ax, 1301h
    int 10h

    mov ah, 02h
    mov al, 2
    mov ch, 0
    mov cl, 5
    mov dh, 0
    mov dl, 80h
    mov bx, 1000h
    int 13h

    mov ah, 03h
    mov al, 2
    mov ch, 0
    mov cl, 2
    mov dh, 0
    mov dl, 81h
    int 13h

    xor bx, bx

    mov ah, 02h
    mov dx, 0300h
    int 10h

    mov bp, console_install_message             
    mov cx, 18
    mov bl, 0Ah
    mov ax, 1301h
    int 10h

    mov ah, 02h
    mov dx, 0400h
    int 10h

    mov bp, niyerror_install_message             
    mov cx, 19
    mov bl, 0Fh
    mov ax, 1301h
    int 10h

    mov ah, 02h
    mov al, 1
    mov ch, 0
    mov cl, 10
    mov dh, 0
    mov dl, 80h
    mov bx, 1000h
    int 13h

    mov ah, 03h
    mov al, 1
    mov ch, 0
    mov cl, 7
    mov dh, 0
    mov dl, 81h
    int 13h

    xor bx, bx

    mov ah, 02h
    mov dx, 0400h
    int 10h

    mov bp, niyerror_install_message             
    mov cx, 19
    mov bl, 0Ah
    mov ax, 1301h
    int 10h

    mov ah, 02h
    mov dx, 0500h
    int 10h

    mov bp, niyexec_install_message             
    mov cx, 18
    mov bl, 0Fh
    mov ax, 1301h
    int 10h

    mov ah, 02h
    mov al, 3
    mov ch, 0
    mov cl, 11
    mov dh, 0
    mov dl, 80h
    mov bx, 1000h
    int 13h

    mov ah, 03h
    mov al, 3
    mov ch, 0
    mov cl, 8
    mov dh, 0
    mov dl, 81h
    int 13h

    xor bx, bx

    mov ah, 02h
    mov dx, 0500h
    int 10h

    mov bp, niyexec_install_message             
    mov cx, 18
    mov bl, 0Ah
    mov ax, 1301h
    int 10h

successful_install:
    mov ah, 02h
    mov dx, 1700h
    int 10h

    mov bp, install_successfully_message             
    mov cx, 21
    mov bl, 0Ah
    mov ax, 1301h
    int 10h

    mov ah, 02h
    mov dx, 1800h
    int 10h

    mov bp, keypress_message             
    mov cx, 37
    mov bl, 0Fh
    mov ax, 1301h
    int 10h

    mov ah, 00h
    int 16h

    cmp al, 'r'
    je reboot_press

    cmp al, 's'
    je shutdown_press

    jmp successful_install

shutdown_press:
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

reboot_press:
    cli
    mov al, 0FEh
    out 64h, al

load_message db 'NIYOS bootinstaller', 0

hddboot_install_message db 'Install hddboot...', 0
console_install_message db 'Install console...', 0
niyfs_install_message db 'Install niyfs...', 0
niyerror_install_message db 'Install niyerror...', 0
niyexec_install_message db 'Install niyexec...', 0

install_successfully_message db 'Install successfully!', 0
keypress_message db 'Press R to reboot or S to shutdown...', 0

times(1024-($-0500h)) db 0