org 7c00h

start:
    cli
    xor ax, ax
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 7c00h
    sti

    mov ax, 0003h
    int 10h

    mov ah, 02h
    mov al, 2
    mov ch, 0
    mov cl, 2
    mov dh, 0
    mov dl, 80h
    mov bx, 500h
    int 13h

    xor ax, ax
    xor cx, cx
    xor dx, dx
    xor bx, bx

    mov ah, 0a1h
    jmp 0000:0500h

times(512-2-($-07c00h)) db 0
db 055h, 0AAh