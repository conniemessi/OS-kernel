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
mov ah,13h
mov al,1	
mov bl,11110100B	;
mov bh,0	;
mov dh,02
mov dl,01	;控制显示在屏幕左上1/2处
int 10h

;call delay

mov ah,13h
mov al,1				
mov bp,str2		
mov cx,str2_l
mov bl,11110100B
mov bh,0
mov dh,04
mov dl,01	;控制显示在屏幕左上1/2处	
int 10h

;call delay

mov ah,13h
mov al,1
mov bp,str3	
mov cx,str3_l	
mov bx,11110011B	
mov dh,06
mov dl,01	;控制显示在屏幕左上1/2处
int 10h

;call delay

;提示用户按任意键退出该用户程序
mov ah,13h
mov al,1
mov bp,str4	
mov cx,str4_l	
mov bx,11110001B 		
mov dh,08
mov dl,01	;控制显示在屏幕左上1/2处
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

str1 db 'I am user 1.'
str_l equ $-str1

str2 db 'My program is running.'
str2_l equ $-str2

str3 db 'Program complete.'
str3_l equ $-str3

str4 db 'Press any key for 4 times to exit.'
str4_l equ $-str4

times 512-($-$$) db 0	;填充剩余扇区0



