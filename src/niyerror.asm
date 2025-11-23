org 1500h

error_interrupt:
    mov bp, shutdown_error_message
    mov cx, 12
    mov dx, 0c22h
    cmp ah, 0e0h
    je error_message_print

    mov bp, reboot_error_message
    mov cx, 10
    mov dx, 0c23h
    cmp ah, 0e1h
    je error_message_print

    mov bp, invalid_command_error_message
    mov cx, 10
    mov dx, 0c23h
    cmp ah, 01h
    je error_message_print

    mov bp, cannot_find_addres_mark_error_message
    mov cx, 14
    mov dx, 0c21h
    cmp ah, 02h
    je error_message_print

    mov bp, sector_not_found_error_message
    mov cx, 14
    mov dx, 0c21h
    cmp ah, 04h
    je error_message_print

    mov bp, bad_sector_detected_error_message
    mov cx, 12
    mov dx, 0c22h
    cmp ah, 0Ah
    je error_message_print

    mov bp, disk_undefined_error_message
    mov cx, 12
    mov dx, 0c22h
    cmp ah, 0BBh
    je error_message_print

    mov bp, write_fault_error_message
    mov cx, 14
    mov dx, 0c21h
    cmp ah, 0CCh
    je error_message_print

    mov bp, unknown_error_message
    mov cx, 10
    mov dx, 0c23h
    cmp ah, 00h
    jne error_message_print

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

    xor ax, ax
    xor cx, cx
    xor dx, dx
    xor bx, bx

    jmp 0000:0500h

error_message_print:
    mov ah, 02h
    int 10h
       
    mov bl, 0CFh
    mov ax, 1301h
    int 10h

    mov ah, 00h

    jmp error_interrupt

shutdown_error_message db 'SHUTDOWN_ERR', 0
reboot_error_message db 'REBOOT_ERR', 0

invalid_command_error_message db 'INVALID_COMM', 0
cannot_find_addres_mark_error_message db 'NOFINDADDR_ERR', 0
sector_not_found_error_message db 'NOTSECTORFOUND', 0
bad_sector_detected_error_message db 'BADSECTOR_ER'
disk_undefined_error_message db 'DISKUNDEF_ER'
write_fault_error_message db 'WRITEFAULT_ERR'

unknown_error_message db 'UNKNOWN_ER'

times(512-1-($-01500h)) db 1
db 0FFh