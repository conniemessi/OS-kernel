[bits 16]
global interrupt_init,insert_interrupt_vector,load_user,run_user
global interrupt_num:data,interrupt_vector_offset:data
global schedule_end

extern main		;forbid run this file any time
extern screen_init
extern isProcessRun
extern schedule 

jmp main

interrupt_init:
	mov ax,0		;init ss regsiter
	mov ss,ax

	mov ax,cs
	mov ds,ax

	;#1  setting up time interrupt 
	mov ax,0x1c
	mov [ interrupt_num], ax
	mov ax, timer_interrupt_process
	mov [ interrupt_vector_offset],ax
	call insert_interrupt_vector



	;#2 int 33
	mov ax,0x33
	mov [ interrupt_num], ax
	mov ax, process_int33
	mov [ interrupt_vector_offset],ax
	call insert_interrupt_vector
	
	;#3 int 34
	mov ax,0x34
	mov [ interrupt_num], ax
	mov ax, process_int34
	mov [ interrupt_vector_offset],ax
	call insert_interrupt_vector

	;#4 int 35
	mov ax,0x35
	mov [ interrupt_num], ax
	mov ax, process_int35
	mov [ interrupt_vector_offset],ax
	call insert_interrupt_vector

	;#5 int 36
	mov ax,0x36
	mov [ interrupt_num], ax
	mov ax, process_int36
	mov [ interrupt_vector_offset],ax
	call insert_interrupt_vector

ret

timer_interrupt_process:
	push ax
	mov ax,0
	mov ds,ax
	mov byte al,[ isProcessRun]
	mov ah,0
	cmp al,ah
	je print_corner
	pop ax
	jmp schedule
		
schedule_end:
	push ax
	mov al, 20h
	out 20h,al
	out 0A0h,al
	pop ax
	sti
iret

print_corner:
		pop ax
		push ax
		push dx
		push bx
		mov ax,cs
		mov ds,ax

		mov ax,0xb800
		mov es,ax

		mov dl,30
		mov al,[ pointer]		; alert:  must be al  dont ax
		cmp al,dl
		jle next_print_c
		mov byte [ pointer], 0
		jmp cotinue_corner

		next_print_c:
		mov eax, 0
		mov eax, cornerstring
		mov ebx,0
		mov bl,[ pointer]			;ebx is added sum
		add eax,ebx
		mov al,[ eax]

		inc bl 
		mov [ pointer],bl

		mov bx,3998D
		mov [ es:bx],al

		cotinue_corner:
		pop bx
		pop dx
		pop ax

jmp schedule_end	

process_int33:
	mov ax,0xb800
	mov es,ax

	mov cx,220D     ;stop           
	mov bx,180D     ;stat

    ;h0 direction
	loop_int33_h0:
	    mov byte [es:bx],'A'
	    inc bx
	    mov byte [es:bx],78D;font color
	    inc bx
	    cmp bx,cx
	    jle loop_int33_h0

	;h1 direction
	mov cx,1820D    ;stop        
	mov bx,220D     ;stat

	loop_int33_h1:
	    mov byte [es:bx],'B'
	    inc bx
	    mov byte [es:bx],78D;font color
	    add bx, 159D
	    cmp bx,cx
	    jle loop_int33_h1

    ;h2 direction
    mov cx,1780D    ;end
    mov bx,1820D    ;strat
    loop_int33_h2:
        mov byte [es:bx],'C'
        dec bx
        mov byte [es:bx],78D
        dec bx
        cmp bx,cx
        ja loop_int33_h2   
   
    ;h3 direction
    mov cx,1780D
    mov bx,180D
    loop_int33_h3:
        mov byte[es:bx],'D'
        inc bx
        mov byte[es:bx],78D
        add bx,159D
        cmp bx,cx
        jle loop_int33_h3
    
iret

process_int34:
	mov ax,0xb800
	mov es,ax
        
	mov bx,260D     ;stat
    mov cx,300D     ;stop   
    ;h0 direction
	loop_int34_h0:
	    mov byte [es:bx],'+'
	    inc bx
	    mov byte [es:bx],78D;font color
	    inc bx
	    cmp bx,cx
	    jle loop_int34_h0

	;h1 direction	  
	mov bx,300D     ;stat
    mov cx,1900D    ;stop      
	loop_int34_h1:
	    mov byte [es:bx],'-'
	    inc bx
	    mov byte [es:bx],78D;font color
	    add bx, 159D
	    cmp bx,cx
	    jle loop_int34_h1

    ;h2 direction
    mov bx,1900D    ;strat
    mov cx,1860D    ;end
    
    loop_int34_h2:
        mov byte [es:bx],'*'
        dec bx
        mov byte [es:bx],78D
        dec bx
        cmp bx,cx
        ja loop_int34_h2   
   
    ;h3 direction
    mov bx,260D
    mov cx,1860D
    loop_int34_h3:
        mov byte[es:bx],'%'
        inc bx
        mov byte[es:bx],78D
        add bx,159D
        cmp bx,cx
        jle loop_int34_h3
          
iret

process_int35:
	mov ax,0xb800
	mov es,ax
        
	mov bx,2100D     ;stat
    mov cx,2140D     ;stop   
    ;h0 direction
	loop_int35_h0:
	    mov byte [es:bx],'a'
	    inc bx
	    mov byte [es:bx],78D;font color
	    inc bx
	    cmp bx,cx
	    jle loop_int35_h0

	;h1 direction	  
	mov bx,2140D    ;stat
    mov cx,3740D    ;stop      
	loop_int35_h1:
	    mov byte [es:bx],'b'
	    inc bx
	    mov byte [es:bx],78D;font color
	    add bx, 159D
	    cmp bx,cx
	    jle loop_int35_h1

    ;h2 direction
    mov bx,3740D    ;strat
    mov cx,3700D    ;end
    
    loop_int35_h2:
        mov byte [es:bx],'c'
        dec bx
        mov byte [es:bx],78D
        dec bx
        cmp bx,cx
        ja loop_int35_h2   
   
    ;h3 direction
    mov bx,2100D
    mov cx,3700D
    loop_int35_h3:
        mov byte[es:bx],'d'
        inc bx
        mov byte[es:bx],78D
        add bx,159D
        cmp bx,cx
        jle loop_int35_h3
          
iret

process_int36:
	mov ax,0xb800
	mov es,ax
        
	mov bx,2180D     ;stat
    mov cx,2220D     ;stop   
    ;h0 direction
	loop_int36_h0:
	    mov byte [es:bx],'a'
	    inc bx
	    mov byte [es:bx],78D;font color
	    inc bx
	    cmp bx,cx
	    jle loop_int36_h0

	;h1 direction	  
	mov bx,2220D    ;stat
    mov cx,3820D    ;stop      
	loop_int36_h1:
	    mov byte [es:bx],'b'
	    inc bx
	    mov byte [es:bx],78D;font color
	    add bx, 159D
	    cmp bx,cx
	    jle loop_int36_h1

    ;h2 direction
    mov bx,3820D    ;strat
    mov cx,3780D    ;end
    
    loop_int36_h2:
        mov byte [es:bx],'c'
        dec bx
        mov byte [es:bx],78D
        dec bx
        cmp bx,cx
        ja loop_int36_h2   
   
    ;h3 direction
    mov bx,2180D
    mov cx,3780D
    loop_int36_h3:
        mov byte[es:bx],'d'
        inc bx
        mov byte[es:bx],78D
        add bx,159D
        cmp bx,cx
        jle loop_int36_h3
          
iret

; load_user( shanqu_num);
load_user:
	;load os to mem

	mov ax,cs
	mov es,ax

	mov cx,1;扇区号参数
	
	mov dx,bp	;backup
	mov bp,sp
	mov ch,[ bp+4]		
	mov bx,[ bp+8]
	
	mov bp,dx

	mov dl,0		; 软盘
	mov dh,0		; 磁头:正面

	xor ax,ax
	mov es,ax  
	mov ax,0215h	;count 

	int 13h
ret


run_user:
	push ecx
	push ax
	call screen_init

;---------------------update 09 vector-------------
	cli
	mov ax,0
	mov es,ax
	mov ecx,[ es:36]			;backup
	mov [ press],ecx

	mov ax,0x09
	mov [ interrupt_num], ax
	mov ax, key_detect
	mov [ interrupt_vector_offset],ax
	call insert_interrupt_vector
	mov ax,0
	mov [i],ax
	sti
;--------------------run--------------------------
	call 0x1000

;--------------------reset 09 vector-------------
	mov ax,0
	mov es,ax
	mov ecx,[press]
	mov [ es:36],ecx

	pop ax
	pop ecx
ret
		
key_detect:
	cli
	push ax
	push bx
	mov ax,0xb800
	mov es,ax

	in al,60h
	in al,61h
	or al,80h
	out 61h,al
	mov al,61h
	out 20h,al

	mov bl,0
	mov bh,[j]
	cmp bl,bh
	je change1
	
	mov bh,0
	mov [j],bh
	mov byte [es:00],'O'
	mov byte [es:02],'U'
	mov byte [es:04],'C'
	mov byte [es:06],'H'

	jmp next_de

	change1:
	mov bh,1
	mov [j],bh

	mov byte [es:00],' '
	mov byte [es:02],' '
	mov byte [es:04],' '
	mov byte [es:06],' '

	next_de:
	
	mov bl,[i]
	inc bl
	mov [i],bl
	mov bh,8		;press key 8 times
	cmp bh,bl
	jle closesti
	jmp niret
	closesti:
		mov cl,'A'
		
	niret:

	pop bx
	pop ax
	sti	
iret


insert_interrupt_vector:
	mov ax,0
	mov es,ax
	mov bx,[ interrupt_num]
	shl bx,2 ;interrupt num * 4 = entry
	mov ax,cs
	shl eax,8  ;shl 8 bit   *16
	mov ax,[ interrupt_vector_offset]
	mov [es:bx], eax
ret

var:
	interrupt_num dw 0x1c				;init
	interrupt_vector_offset dw 0x7c00	;init
	pointer db 0
	cornerstring db 'AAAAAAAAAABBBBBBBBBBCCCCCCCCCC'

i db 0		;counter
j db 0		;reverse every time  0101
flag db 0
press dw 0
offset_1 dw 0

