[bits 16]
extern main		;forbid run this file any time
jmp main

global clear,get_time,get_second
global get_date,get_year
global flag_position:data,flag_scroll_up
global print_message 
global print_welcome_msg 
global init_flag_position,print_corner
global set_pointer_pos,flag_scroll,print_flag
global scroll_screen,saveall_reg_seg,restart_reg_seg
global saveall_reg,restart_reg
global screen_init,input_char,printToscn
global get_pointer_pos
global schedule_end
input_char:
	mov ah,0x00; listen keyboard  return value is save in ax	
	int 16h	
ret

screen_init:               
	push ax
	push bx
	push cx
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
	jle loop	;<=

	pop cx
	pop bx
	pop ax
ret

printToscn:			;显示输入的sequence
	mov ax,ds
	mov es,ax

	mov ah,0x0e
	mov bl,0x0e
	mov cx,bp	;cx is temp  bp don't change
	mov bp,sp		; this step is very important
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

clear:			;clear the screen

	push ax
	mov ax,0x0000
	mov [ flag_position], ax
	pop ax
	call screen_init
ret 

init_flag_position:
	mov ax,0x1000
	mov [ flag_position],ax 
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

print_welcome_msg:		;param ( string, len, position) 
	mov ax,cs
	mov es,ax
	mov ds,ax

	push bp	
	mov bp, msg;[bp+4]
	mov cx,msg_l;[bp+6]

	mov ax,1301h	;01 只有字符串
	mov bx,01101111B		;Bh is font color
	mov dx,0317h	;position
	int 10h
	pop bp
ret 

print_message:		;  descripatoin
	mov ax,cs
	mov es,ax
	mov ds,ax
	push bp
	mov bp, msg2;[bp+4]
	mov cx,msg2_l;[bp+6]

	mov ax,1301h	;01 只有字符串
	mov bx,01100001B		;Bh is font color
	mov dx,0505h	;position
	int 10h
	pop bp
ret 

screen_init_last_line:               ;make last line white
	mov ax,0xb800
	mov es,ax
	mov ax,00
	mov cx,3999
	mov bx,3872

	loop_2:
	mov byte [es:bx],' '
	inc bx
	mov byte [es:bx],01100001B;font color
	inc bx
	cmp bx,cx
	jle loop_2

ret

print_flag:		

	mov ax,cs
	mov ds,ax
	mov es,ax

	mov ax,1301h	;01 只有字符串
	mov bx,01101111B		;Bh is font color
;	mov dx,1305h	;position
	mov dx, [flag_position]	;position
	push bp
	mov bp, msg3
	mov cx,msg3_l

	int 10h
	pop bp
	call screen_init_last_line   ;for some compatible questions when scrolling
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

;-----------------------CPU mutiply process
extern _cs,_flags,_ip
saveall_reg_seg:
	mov [ _ip],ax
	mov [ _cs],bx
	mov [ _flags],cx
	pop si
	pop di
	mov [ _sp],sp
	push di
	push si
ret

restart_reg_seg:
	mov ax,[ _ip]
	mov bx,[ _cs]
	mov cx,[ _flags]

	pop si			;ret
	pop di

	mov sp,[ _sp]

	push cx		;flags
	push bx		;cs
	push ax		;ip

	push di
	push si
ret

extern _ax,_bx,_cx,_dx,_es,_ds,_sp,_bp,_si,_di,_fs,_gs,_ss
saveall_reg:
	mov [_es],es
	mov [_ds],ds
	mov [_gs],gs
	mov [_fs],fs
	mov [_ss],ss

	mov [_ax],ax
	mov [_bx],bx
	mov [_cx],cx
	mov [_dx],dx
	mov [_di],di
	mov [_si],si
	mov [_bp],bp
ret

restart_reg:

	mov bp, [_bp]

	mov es, [_es]
	mov ds, [_ds]
	mov gs, [_gs]
	mov fs, [_fs]
	mov ss, [_ss]
                 
	mov ax, [_ax]
	mov bx, [_bx]
	mov cx, [_cx]
	mov dx, [_dx]
	mov di, [_di]
	mov si, [_si]
ret

;------------------DATA-------------------
var:

msg:
	db 'Welcome to Ren Wendi OS'
msg_l equ $-msg

msg2:					;style 01100001B
	db `System programs -- date,time \r\n     Type <time> / <date>.\r\n\r\n     User programs   -- use1,use2 \r\n     Type<run number>, for example:run 12 \r\n\r\n     Processes       -- Type <start> to start run all processes\r\n\r\n     Ints            -- int 33h/34h/35h/36h \r\n     Type <int numberh> , for example:int 33h    `
msg2_l equ $-msg2

msg3:
	db 'ren@ren-Inspiron:~$ '
msg3_l equ $-msg3

flag_position dd 0x1000
	
format_line:
	db '                                                            '
format_line_l equ $-format_line








