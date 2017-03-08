[bits 16]
extern main		;forbid run this file any time
jmp main

global clear,get_time,get_second
global get_date,get_year,load_user,run_user

extern flag_position 
extern screen_init 

clear:			;clear the screen

	push ax
	mov ax,0x0000
	mov [ flag_position], ax
	pop ax
	call screen_init
ret 

get_time:
	mov ah,0x02
	int 0x1a
	mov ax,cx
ret

get_second:
	mov ah,0x02
	int 0x1a
	mov ax,dx
ret

get_year:
	mov ah,0x04
	int 0x1a
	mov ax,cx
ret

get_date:
	mov ah,0x04
	int 0x1a
	mov ax,dx
ret

load_user:

	mov ax,ds
	mov es,ax

	mov dx,bp
	mov bp,sp
	mov cx,[bp+4];扇区号参数
	mov bp,dx

	xor ax,ax
	mov es,ax 
	mov bx,1000h ;加载到1000h内存位置
	mov ax,0201h 
	mov dx,0
	int 13h
ret


run_user:
	call 0x1000
ret
		




