org 1000h

push ax
push cx
push dx

mov ax,cs
mov es,ax
mov ds,ax

push bp

mov bp,str1
mov cx,str_l
mov ax,1301h	
mov bl,11110100B	;
mov bh,0	;
mov dh,14
mov dl,01	;控制显示在屏幕左下1/2处
int 10h
			
mov bp,str2	
mov cx,str2_l
mov ax,1301h	
mov bx,11111110B		
mov dh,16
mov dl,01	;控制显示在屏幕左下1/2处	
int 10h

mov bp,str3	
mov cx,str3_l
mov ax,1301h	
mov bx,11110011B		
mov dh,18
mov dl,01	;控制显示在屏幕左下1/2处
int 10h

;提示用户按任意键退出该用户程序
mov bp,str4	
mov cx,str4_l
mov ax,1301h	
mov bx,11110001B		
mov dh,20
mov dl,01	;控制显示在屏幕左下1/2处
int 10h

pop bp
pop dx
pop cx
pop ax


;LISTEN_EXIT----
listen:
	mov ch,'A'
	cmp ch,cl
jne listen 

;--------------------

ret				;结束后返回操作系统


;=============字符串内容===============

str1:
	db 'I am user 3.'
str_l equ $-str1

str2:
	db 'My program is running.'
str2_l equ $-str2

str3:
	db 'Program complete.'
str3_l equ $-str3

str4:
	db 'Press any key for 4 times to exit.'
str4_l equ $-str4

times 512-($-$$) db 0	;填充剩余扇区0



