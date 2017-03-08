org 2000h

sti

mov ax,0xb800
mov es,ax

mov al,'!'  
mov dl,01000101B  
again:
	mov bx,260D     ;stat
    mov cx,300D     ;stop 


loop_int34_h0:
    mov byte [es:bx],al
    inc bx
    mov byte [es:bx],dl;font color
    inc dl
    inc bx
    call delay
    cmp bx,cx
    jle loop_int34_h0

	;h1 direction
	mov bx,300D     ;stat
    mov cx,1900D    ;stop

loop_int34_h1:
    mov byte [es:bx],al
    inc bx
    mov byte [es:bx],dl;font color
    inc dl
	add bx, 159D
	call delay
    cmp bx,cx
    jle loop_int34_h1

    ;h2 direction
    mov bx,1900D    ;strat
    mov cx,1860D    ;end
    
loop_int34_h2:
    mov byte [es:bx],al
    dec bx
    mov byte [es:bx],dl
    inc dl
    dec bx
    call delay
    cmp bx,cx
    ja loop_int34_h2   
   
    ;h3 direction   
    mov bx,1860D     ;start
    mov cx,260D    ;end
    
loop_int34_h3:
    mov byte[es:bx],al
    inc bx
    mov byte[es:bx],dl
    inc dl
    sub bx,161D
    call delay
    cmp bx,cx
    ja loop_int34_h3

    
mov byte [es:1078],'W'
call delay
call delay
mov byte [es:1080],'E'
call delay
call delay
mov byte [es:1082],'N'	
call delay
call delay
call delay
call delay

	inc al
	cmp al,'/'
	jle again
	mov al,'!'
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
