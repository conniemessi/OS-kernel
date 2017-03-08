call clean_s;清屏

org 0a700h

mov ax,cs
mov es,ax
mov ds,ax

mov bp,str1
mov cx,str_l
mov ax,1301h	
mov bl,11110100B	;
mov bh,0	;
mov dh,14
mov dl,01	;控制显示在屏幕左下1/2处
int 10h

call delay
			
mov bp,str2	
mov cx,str2_l
mov ax,1301h	
mov bx,11111110B		
mov dh,16
mov dl,01	;控制显示在屏幕左下1/2处	
int 10h

call delay

mov bp,str3	
mov cx,str3_l
mov ax,1301h	
mov bx,11110011B		
mov dh,18
mov dl,01	;控制显示在屏幕左下1/2处
int 10h

call delay

;提示用户按任意键退出该用户程序
mov bp,str4	
mov cx,str4_l
mov ax,1301h	
mov bx,11110001B		
mov dh,20
mov dl,01	;控制显示在屏幕左下1/2处
int 10h

;等待用户键入
mov ah,0x00
int 0x16

ret				;结束后返回操作系统

;-----------------------FUNTION---------------
clean_s:
mov ax,0600h
mov bh,0 
mov cx,00
mov dx,184fh
int 10h
ret

delay:
	mov dx,00
	delay2:
		mov cx,00
		delay1:
			inc cx
			cmp cx,30000D
		jne delay1
		inc dx
		cmp dx,30000D
	jne delay2

	ret

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
	db 'Press any key to exit.'
str4_l equ $-str4

times 512-($-$$) db 0	;填充剩余扇区0



