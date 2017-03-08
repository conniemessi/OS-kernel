org 0x3000		;加载到 e0000内存中执行
sti

mov ax,0xb800
mov es,ax

mov al,'a'
mov dl,00110100B    
again:
	mov bx,2100D     ;stat
    mov cx,2140D     ;stop 


loop_int35_h0:
    mov byte [es:bx],al
    inc bx
    mov byte [es:bx],dl;font color
    inc bx
    inc dl
    call delay
    cmp bx,cx
    jle loop_int35_h0

	;h1 direction
	mov bx,2140D     ;stat
    mov cx,3740D    ;stop

loop_int35_h1:
    mov byte [es:bx],al
    inc bx
    mov byte [es:bx],dl;font color
    inc dl
	add bx, 159D
	call delay
    cmp bx,cx
    jle loop_int35_h1

    ;h2 direction
    mov bx,3740D    ;strat
    mov cx,3700D    ;end
    
loop_int35_h2:
    mov byte [es:bx],al
    dec bx
    mov byte [es:bx],dl
    inc dl
    dec bx
    call delay
    cmp bx,cx
    ja loop_int35_h2   
   
    ;h3 direction   
    mov bx,3700D     ;start
    mov cx,2100D    ;end
    
loop_int35_h3:
    mov byte[es:bx],al
    inc bx
    mov byte[es:bx],dl
    inc dl
    sub bx,161D
    call delay
    cmp bx,cx
    ja loop_int35_h3

    
mov byte [es:2920],'D'
call delay
call delay
mov byte [es:2922],'I'
call delay
call delay
call delay
call delay

	inc al
	cmp al,'z'
	jle again
	mov al,'a'
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
