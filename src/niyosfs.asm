org 1000h

command_select:
    cmp ah, 0bh
    je dir_files

    cmp ah, 0ch
    je mk_file

    cmp ah, 0dh
    je write_file

    cmp ah, 0ah
    je delete_file

    mov ah, 10h
    int 16h

    xor bx, bx

    jmp 7cc8h

dir_files:
    mov ax, 0003h
    int 10h

    mov dh, 00h
    mov cl, 01h
dir_files_loop:
    push dx

    mov ah, 02h
    mov al, 1
    mov ch, 0
    mov dh, 0
    mov dl, 80h
    mov bx, file_buffer
    int 13h

    pop dx

    mov si, 00h

    inc cl

    mov al, [file_buffer+0]
    cmp al, 1ch
    je dir_files_lines

    cmp al, 00h
    je dir_files_done

    jmp dir_files_loop
dir_files_lines:
    xor bx, bx

    mov ah, 02h
    mov dl, 00h
    int 10h

    inc dh
print_dir_files_file_name:
    inc si

    mov al, [file_buffer+si]
    cmp al, 00h
    je dir_files_loop

    mov ah, 0eh
    int 10h

    jmp print_dir_files_file_name
dir_files_done:
    jmp command_select

;find_file:
;    mov cl, 01h
;find_file_loop:
;    mov ah, 02h
;    mov al, 1
;    mov ch, 0
;    mov dh, 0
;    mov dl, 80h
;    mov bx, file_buffer
;    int 13h

;    mov bx, 0
;
;    inc cl
;
;    mov al, [file_buffer+0]
;    cmp al, 00h
;    jne find_file_cmp_name
;
;    jmp find_file_done
;find_file_cmp_name:
;    inc bx
;
;    mov dl, [file_buffer+bx]
;
;    cmp dl, 00h
;    je find_file_done
;
;    cmp dl, [di+bx-1]
;    je find_file_cmp_name
;
;    jmp find_file_loop
;find_file_done:
;    dec cl
;file_point_cmp:
;    jmp command_select

delete_file:
    mov cl, 01h
search_file_to_delet:
    push dx

    mov ah, 02h
    mov al, 1
    mov ch, 0
    mov dh, 0
    mov dl, 80h
    mov bx, file_buffer
    int 13h

    pop dx

    mov bx, 0
 
    inc cl

    mov al, [file_buffer+0]
    cmp al, 00h
    jne detele_file_cmp_name

    jmp delete_file_done
detele_file_cmp_name:
    inc bx

    mov al, [file_buffer+bx]

    cmp al, 00h
    je delete_file_copyto_loop

    cmp al, [di+bx-1]
    je detele_file_cmp_name

    jmp search_file_to_delet
delete_file_copyto_loop:
    mov ah, 02h
    mov al, 1
    mov ch, 0
    mov dh, 0
    mov dl, 80h
    mov bx, file_buffer
    int 13h

    mov al, [file_buffer+0]
    cmp al, 00h
    jne delete_file_copyto

    jmp delete_file_done
delete_file_copyto:
    dec cl

    mov ah, 03h
    mov al, 1
    mov ch, 0
    mov dh, 0
    mov dl, 80h
    mov bx, file_buffer
    int 13h

    add cl, 2

    jmp delete_file_copyto_loop
delete_file_done:
    dec cl

    mov ah, 03h
    mov al, 1
    mov ch, 0
    mov dh, 0
    mov dl, 80h
    mov bx, file_buffer
    int 13h

    jmp command_select

mk_file:
    mov dl, 1Ch
    mov cl, 01h
    mov si, 00h
search_empty_mk_file:
    push dx

    mov ah, 02h
    mov al, 1
    mov ch, 0
    mov dh, 0
    mov dl, 80h
    mov bx, file_buffer
    int 13h

    pop dx

    mov bx, 0

    inc cl

    mov al, [file_buffer+0]
    cmp al, 00h
    jne search_empty_mk_file
create_point_mk_file:
    mov [file_buffer+0], dl
create_name_mk_file:
    inc bx

    mov al, [di+bx-1]

    cmp al, 00h
    je mk_file_done

    mov [file_buffer+bx], al

    jmp create_name_mk_file
mk_file_done:
    dec cl

    mov ah, 03h
    mov al, 1
    mov ch, 0
    mov dh, 0
    mov dl, 80h
    mov bx, file_buffer
    int 13h

    jmp command_select

write_file:
    mov cl, 01h
find_write_file:
    mov ah, 02h
    mov al, 1
    mov ch, 0
    mov dh, 0
    mov dl, 80h
    mov bx, file_buffer
    int 13h

    mov bx, 0

    inc cl

    mov al, [file_buffer+0]
    cmp al, 00h
    jne write_file_cmp_name

    jmp exit_write_file
write_file_cmp_name:
    inc bx

    mov dl, [file_buffer+bx]

    cmp dl, 00h
    je write_find_file_done1

    cmp dl, [di+bx-1]
    je write_file_cmp_name

    jmp find_write_file
write_find_file_done1:  
    dec cl
    mov [writeble_file_num], cl

    mov ah, 02h
    mov al, 1
    mov ch, 0
    mov dh, 0
    mov dl, 80h
    mov bx, file_buffer
    int 13h
write_find_file_done2:
    mov ax, 0003h
    int 10h

    mov si, 1
    mov cl, 0
print_write_file_name_loop:
    cmp [file_buffer+si], 0
    je write_file_point

    mov ah, 0eh
    mov al, [file_buffer+si]
    int 10h

    inc si
    inc cl

    jmp print_write_file_name_loop
write_file_point:
    xor bx, bx

    mov ah, 02h
    mov dh, 00h
    mov dl, cl
    int 10h

    mov bp, text_point             
    mov cx, 3
    mov bl, 07h
    mov ax, 1301h
    int 10h

    mov ah, 02h
    mov dx, 0100h
    int 10h

    inc si
print_write_file_buffer:
    mov al, [file_buffer+si]

    cmp al, 00h
    je write_file_keyboard_loop

    mov ah, 0eh
    int 10h

    inc si

    jmp print_write_file_buffer
write_file_keyboard_loop:
    mov ah, 10h
    int 16h

    cmp ah, 0eh
    jz del_sim

    cmp ah, 3bh
    jz save_file_writ

    cmp ah, 3ch
    jz exit_write_file

    mov [file_buffer+si], al

    inc si
    inc cl

    jmp write_find_file_done2
del_sim:
    cmp si, 0
    je write_file_keyboard_loop

    dec si
    mov [file_buffer+si], 0
    jmp write_find_file_done2
save_file_writ:
    mov ah, 03h
    mov al, 1
    mov ch, 0
    mov cl, [writeble_file_num]
    mov dh, 0
    mov dl, 80h
    mov bx, file_buffer
    int 13h

    jmp write_file_keyboard_loop
exit_write_file:
    jmp command_select

text_point db '.t', 0

writeble_file_num db 0

file_buffer db 512 dup(1)
times(1024-($-01000h)) db 0