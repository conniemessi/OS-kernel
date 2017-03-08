org 0x1000
sti

mov ax,0xb800
mov es,ax

mov al,'A' 
mov dl,00010011B  
again:              
    mov bx,180D     ;stat
    mov cx,220D     ;stop

loop_int33_h0:
    mov byte [es:bx],al
    inc bx
    mov byte [es:bx],dl;font color
    inc bx
    inc dl
    call delay
    cmp bx,cx
    jle loop_int33_h0

	;h1 direction
	mov bx,220D     ;stat
	mov cx,1820D    ;stop        
	
loop_int33_h1:
    mov byte [es:bx],al
    inc bx
    mov byte [es:bx],dl;font color
    inc dl
	add bx, 159D
	call delay
    cmp bx,cx
    jle loop_int33_h1

    ;h2 direction
    mov bx,1820D    ;strat
    mov cx,1780D    ;end
        
loop_int33_h2:
    mov byte [es:bx],al
    dec bx
    mov byte [es:bx],dl
    inc dl
    dec bx
    call delay
    cmp bx,cx
    ja loop_int33_h2   
   
    ;h3 direction   
    mov bx,1780D     ;start
    mov cx,180D    ;end
    
loop_int33_h3:
    mov byte[es:bx],al
    inc bx
    mov byte[es:bx],dl
    inc dl
    sub bx,161D
    call delay
    cmp bx,cx
    ja loop_int33_h3

    
mov byte [es:998],'R'
mov byte [es:999],0x17
call delay
call delay
mov byte [es:1000],'E'
mov byte [es:1001],0x26
call delay
call delay
mov byte [es:1002],'N'
mov byte [es:1003],0x35
call delay
call delay
call delay
call delay


	inc al
	cmp al,'Z'
	jle again
	mov al,'A'
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
