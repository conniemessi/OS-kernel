[bits 16]
global print_welcome_str 
global screen_init, print_message 
global input_char,printT,get_pointer_pos
global set_pointer_pos,print_flag,scroll_screen,flag_scroll
global flag_position:data,flag_scroll_up,init_ss
global init_flag_position


extern main		;forbid run this file any time
jmp main

init_ss:
	mov ax,0
	mov ss,ax
ret

init_flag_position:
	mov ax,0x1000
	mov [ flag_position],ax 
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
	mov bp, str;[bp+4]
	mov cx,str_l;[bp+6]

	mov ax,1301h	
	mov bx,01101111B		
	mov dx,0517h	
	int 10h
	pop bp
ret 

print_message:		
	mov ax,cs
	mov es,ax
	mov ds,ax
	push bp
	mov bp, str2;[bp+4]
	mov cx,str2_l;[bp+6]

	mov ax,1301h	
	mov bx,01100001B		
    mov dx,0805h	
    int 10h
	pop bp
ret 

print_flag:	
    mov ax,cs
	mov ds,ax
	mov es,ax

	mov ax,1301h	
    mov bx,01101111B	
	mov dx,1305h
    mov dx, [flag_position]	
    push bp
	mov bp, str3
	mov cx,str3_l

	int 10h
	pop bp
ret


flag_scroll:		;flag move next line
	push ax
	mov ax,[flag_position]		;flag move down
	add ax,0x100				;next line
	mov [flag_position],ax
	pop ax
ret

flag_scroll_up:		;flag move next line
	push ax
	mov ax,[flag_position]		;flag move down
	sub ax,0x100				;next line
	mov [flag_position],ax
	pop ax
ret

input_char:
	mov ah,0x00 ;监听用户输入
	int 16h	
ret

printT:			;显示输入的sequence
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

get_pointer_pos:
	
	mov ah,0x03 ;功能号
	mov bh,0x00
	int 10h
	mov ax,dx ;return row:col
ret 

set_pointer_pos:
	mov ax,ds
	mov es,ax
	
	mov cx,bp		;cx is temp
	mov bp,sp

	mov ah,0x02 ;功能号
	mov bh,0x00		;页号
;	mov dx,[bp+4]	;行列
	mov dx,[flag_position]	;行列
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



;------------------DATA-------------------
str:
	db 'Welcome to Ren Wendi OS'
str_l equ $-str

str2:		
    db `There are some programs you can choose. \r\n\r\n     Please enter "time"to see the current time of system. \r\n     Please enter "date"to see the current date of system. \r\n     Please enter "clear" to clean the screen. \r\n\r\n     Please enter"run number order" to see 4 user programs. \r\n     Enter for example:"run 1234/132/12..." \r\n`    
str2_l equ $-str2

str3:
	db 'ren@ren-Inspirom:~$ '
str3_l equ $-str3



var:
	flag_position dd 0x1000



