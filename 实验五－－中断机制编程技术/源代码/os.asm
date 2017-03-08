[bits 16]
global print_welcome_str,screen_init, print_message 
global input_char,printT
global set_mouse_pos,get_mouse_pos
global print_cmd,scroll_screen,cmd_scroll
global cmd_position:data,cmd_scroll_up
global init_cmd_position
global printTimeClock
global interrupt_init,insert_interrupt_vector
global interrupt_num:data,interrupt_vector_offset:data

extern main	
jmp main     ;run the cmd

init_cmd_position:
	mov ax,0x1000
	mov [cmd_position],ax 
ret

screen_init:      
	mov ax,0xb800
	mov es,ax
	mov ax,00
	mov cx,3999
	mov bx,00

	loop:
	mov byte [es:bx],' '
	inc bx
	mov byte [es:bx],01100001B;棕色底蓝色字
	inc bx
	cmp bx,cx
	jle loop

ret



print_welcome_str:		
    mov ax,cs
	mov es,ax
	mov ds,ax

	push bp	
	mov bp, str;
	mov cx,str_l;

	mov ax,1301h	
	mov bx,01101111B		
	mov dx,0219h	
	int 10h
	pop bp
ret 

print_message:		
	mov ax,cs
	mov es,ax
	mov ds,ax
	push bp
	mov bp, str2;
	mov cx,str2_l;

	mov ax,1301h	
	mov bx,01100001B		
    mov dx,0400h	
    int 10h
	pop bp
ret 

print_cmd:	
    mov ax,cs
	mov ds,ax
	mov es,ax

	mov ax,1301h	
    mov bx,01101111B	
	mov dx,1305h
    mov dx, [cmd_position]	
    push bp
	mov bp, str3
	mov cx,str3_l

	int 10h
	pop bp
ret


cmd_scroll:		;cmd move next line
	push ax
	mov ax,[cmd_position]		;cmd move down
	add ax,0x100				;next line
	mov [cmd_position],ax
	pop ax
ret

cmd_scroll_up:		;cmd move next line
	push ax
	mov ax,[cmd_position]		;cmd move down
	sub ax,0x100				;next line
	mov [cmd_position],ax
	pop ax
ret

input_char:
	mov ah,0x00 ;监听用户输入
	int 16h	
ret

printT:			;显示输入的单个字符
	mov ax,ds
	mov es,ax

	mov ah,0x0e
	mov bl,0x0e
	mov cx,bp	;cx is temp  bp don't change
	mov bp,sp
	mov al,[bp+4]
	mov bp,cx	;cx is temp
	mov cx,1
	int 10h
ret 

get_mouse_pos:
	
	mov ah,0x03 ;功能号
	mov bh,0x00
	int 10h
	mov ax,dx ;return row:col
ret 

set_mouse_pos:
	mov ax,ds
	mov es,ax
	
	mov cx,bp		;cx is temp
	mov bp,sp

	mov ah,0x02 ;功能号
	mov bh,0x00		;页号
;	mov dx,[bp+4]	;行列
	mov dx,[cmd_position]	;行列
	int 10h
	mov bp,cx
ret 

scroll_screen:
	
	mov ah,0x06 ;功能号
	mov al,0x01		;how many line 
	mov cx,0x0000
	mov dx,0x2580
	mov bh,01100001B
	int 10h
ret 

interrupt_init:
	mov ax,cs
	mov ds,ax

	;--------time interrupt --------
	mov ax,0x1c
	mov [ interrupt_num], ax
	mov ax, printTimeClock
	mov [ interrupt_vector_offset],ax
	call insert_interrupt_vector

	;--------int 33--------
	mov ax,0x33
	mov [ interrupt_num], ax
	mov ax, process_int33
	mov [ interrupt_vector_offset],ax
	call insert_interrupt_vector
	
	;--------int 34--------
	mov ax,0x34
	mov [ interrupt_num], ax
	mov ax, process_int34
	mov [ interrupt_vector_offset],ax
	call insert_interrupt_vector
	
	;--------int 35--------
	mov ax,0x35
	mov [ interrupt_num], ax
	mov ax, process_int35
	mov [ interrupt_vector_offset],ax
	call insert_interrupt_vector

	;--------int 36--------
	mov ax,0x36
	mov [ interrupt_num], ax
	mov ax, process_int36
	mov [ interrupt_vector_offset],ax
	call insert_interrupt_vector
	
insert_interrupt_vector:
	mov ax,0
	mov es,ax
	mov bx,[ interrupt_num]
	shl bx,2    ;interrupt num * 4 = entry
	mov ax,cs
	shl eax,8 
	mov ax,[ interrupt_vector_offset]
	mov [es:bx], eax
ret


printTimeClock:
		mov ax,cs
		mov ds,ax
		mov ax,0xb800
		mov es,ax

		mov dl,30
		mov al,[mouse]		
		cmp al,dl
		jne next_print_c
		mov byte [mouse], 0
		jmp cotinue_timeclock

		next_print_c:
		mov eax, timeclockstring
		mov ebx,0
		mov bl,[mouse]			;ebx is added sum
		add eax,ebx
		mov al,[ eax]

		inc ebx
		mov [mouse],bl

		mov bx,3998D
		mov [es:bx],al

		cotinue_timeclock:
iret

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

;------------------DATA-------------------
str:
	db 'Welcome to Ren Wendi OS'
str_l equ $-str

str2:		
    db `     There are some programs you can choose. \r\n\r\n     Please enter "time"to see the current time of system. \r\n     Please enter "date"to see the current date of system. \r\n     Please enter "clear" to clean the screen. \r\n\r\n     Please enter"run number order" to see 4 user programs. \r\n     Please enter"int33h/34h/35h/36h" to see 4 interrupt programs.\r\n`
str2_l equ $-str2

str3:
	db 'ren@ren-Inspiron:~$ '
str3_l equ $-str3

var:
	interrupt_num dw 0x1c				;init
	interrupt_vector_offset dw 0x7c00	;init
	cmd_position dd 0x1000
	mouse db 0
	timeclockstring db 'AAAAAAAAAABBBBBBBBBBCCCCCCCCCC'
	
	
