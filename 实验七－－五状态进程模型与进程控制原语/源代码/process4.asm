org 0x4000		;加载到 
sti

mov ax,0xb800
mov es,ax

mov al,'0'
mov dl,00000001B    
again:
	mov bx,2180D     ;stat
    mov cx,2220D     ;stop 


loop_int36_h0:
    mov byte [es:bx],al
    inc bx
    mov byte [es:bx],dl;font color
    inc bx
    inc dl
    call delay
    cmp bx,cx
    jle loop_int36_h0

	;h1 direction
	mov bx,2220D     ;stat
    mov cx,3820D    ;stop

loop_int36_h1:
    mov byte [es:bx],al
    inc bx
    mov byte [es:bx],dl;font color
    inc dl
	add bx, 159D
	call delay
    cmp bx,cx
    jle loop_int36_h1

    ;h2 direction
    mov bx,3820D    ;strat
    mov cx,3780D    ;end
    
loop_int36_h2:
    mov byte [es:bx],al
    dec bx
    mov byte [es:bx],dl
    inc dl
    dec bx
    call delay
    cmp bx,cx
    ja loop_int36_h2   
   
    ;h3 direction   
    mov bx,3780D     ;start
    mov cx,2180D    ;end
    
loop_int36_h3:
    mov byte[es:bx],al
    inc bx
    mov byte[es:bx],dl
    inc dl
    sub bx,161D
    call delay
    cmp bx,cx
    ja loop_int36_h3

    
mov byte [es:3000],'O'
call delay
call delay
mov byte [es:3002],'S'
call delay
call delay
call delay
call delay

	inc al
	cmp al,'9'
	jle again
	mov al,'0'
    jmp again


jmp $



;---------;-----------------------FUNTION---------------

delay:
	push dx
	push cx
	mov si,8000D
	mov dx,00
	timer2:	
		mov cx,00
		timer:
			inc cx
			cmp cx,si
		jne timer
		inc dx
		cmp dx,si
	jne timer2
	pop cx
	pop dx
ret


times 512-($-$$) db 0	;填充剩余扇区0
