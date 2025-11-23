org 2500h

jmp chose_command

sb16_irqhandle:
    pusha

    mov dx, 22ah
    in al, dx

    mov al, 20h
    out 20h, al

    popa
    iret

sb16_num equ 0fh
sb16_oldoffset dw 0
sb16_oldsegment dw 0
sb16_dmapage dw 0
sb16_dmaoffset dw 0

sound_data db 0
sound_size equ 1
sound_buffer: times sound_size * 2 db 0

chose_command:
    cmp ah, 0ah
    je pc_speaker

    cmp ah, 1ah
    je sound_blaster

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

pc_speaker:
    mov al, 0b6h
    out 43h, al

    mov ax, 07c4h
    out 42h, al
    mov al, ah
    out 42h, al

    in al, 61h
    or al, 03h
    out 61h, al

    mov cx, 1000
pc_speaker_timer_prog:
    dec cx

    mov al, 36h
    out 43h, al

    mov ax, 4a9h
    out 40h, al
    mov al, ah
    out 40h, al
pc_speaker_timer_loop:
    in al, 40h

    cmp cx, 00h
    je pc_speaker_end

    cmp al, 00h
    je pc_speaker_timer_prog

    jmp pc_speaker_timer_loop
pc_speaker_end:
    in al, 61h
    and al, 0fch
    out 61h, al

    jmp chose_command

sound_blaster:
    mov al, 01h
    mov dx, 226h
    out dx, al

    in al, dx
    in al, dx
    in al, dx
    in al, dx
sound_blaster_reset_loop_done:
    mov al, 00h
    mov dx, 226h
    out dx, al
sound_blaster_reset:
    mov dx, 22ah
    in al, dx
    cmp al, 0aah
    je sound_blaster_speaker_on

    jmp sound_blaster_reset
sound_blaster_speaker_on:
    mov dx, 22ch
    mov al, 0d1h
    out dx, al
sound_blaster_install_isr:
    cli
    mov ax, 0
    mov es, ax
    mov ax, [es:4 * sb16_num]
    mov [sb16_oldoffset], ax
    mov ax, [es:4 * sb16_num + 2]
    mov [sb16_oldsegment], ax
    mov word [es:4 * sb16_num], sb16_irqhandle
    mov word [es:4 * sb16_num + 2], cs
    sti
sound_blaster_enable_irq7:
    in al, 21h
    and al, 7fh
    out 21h, al
sound_blaster_buffer_offset:
    mov ax, cs
    mov dx, ax
    shr dx, 12
    shr ax, 4
    add ax, sound_buffer
    jnc sound_blaster_buffer_offset_cont
    inc dx
sound_blaster_buffer_offset_cont:
    mov cx, 0ffffh
    sub cx, ax
    inc cx
    cmp cx, sound_size
    jae sound_blaster_buffer_offset_done
sound_blaster_buffer_offset_next_page:
    mov ax, 0
    inc dx
sound_blaster_buffer_offset_done:
    mov word [sb16_dmapage], dx
    mov word [sb16_dmaoffset], ax
sound_blaster_fill_buffer:
    mov ax, [sb16_dmapage]
    shr ax, 12
    mov es, ax
    mov di, [sb16_dmaoffset]

    mov si, sound_data
    mov cx, sound_size
    rep movsb
sound_blaster_prog_dma:
    mov dx, 0ah
    mov al, 05h
    out dx, al

    mov dx, 0ch
    mov al, 00h
    out dx, al

    mov dx, 0bh
    mov al, 49h
    out dx, al

    mov dx, 03h
    mov al, (sound_size - 1) and 0ffh
    out dx, al
    mov al, (sound_size - 1) shr 8
    out dx, al

    mov dx, 02h
    mov al, byte [sb16_dmaoffset]
    out dx, al

    mov al, byte [sb16_dmaoffset+1]
    out dx, al

    mov al, byte [sb16_dmapage]
    mov dx, 83h
    out dx, al

    mov dx, 0ah
    mov al, 01h
    out dx, al
sound_blaster_bitrate:
    mov dx, 22ch
    mov al, 40h
    out dx, al

    mov dx, 22ch
    mov al, 0e0h
    out dx, al
sound_blaster_start_playback:
    mov dx, 22ch
    mov al, 14h
    out dx, al

    mov dx, 22ch
    mov al, (sound_size - 1) and 0ffh
    out dx, al

    mov dx, 22ch
    mov al, (sound_size - 1) shr 8
    out dx, al

    jmp sound_blaster_off

sound_blaster_off:
    mov dx, 22ch
    mov al, 0d3h
    out dx, al

    cli
    mov ax, 00h
    mov es, ax
    mov ax, [sb16_oldoffset]
    mov [es:4 * sb16_num], ax
    mov ax, [sb16_oldsegment]
    mov [es:4 * sb16_num + 2], ax
    sti

    in al, 21h
    or al, 80h
    out 21h, al

    jmp chose_command

times(512-($-02500h)) db 1