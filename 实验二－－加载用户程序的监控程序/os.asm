OS_start:

org 8100h;加载到0x8100执行
 
;=============inition=============
call clean_s;清屏，并且显示颜色
call inition;变量初始化，均为0

;=============welcome=============
mov ax,cs
mov ds,ax
mov es,ax
	 
mov ah,13h
mov al,1
mov bh,0
mov bl,01100001B ;棕色底蓝色字
mov dh,05h
mov dl,10h
mov bp,str1
mov cx,str1_length
int 10h

mov ah,13h
mov al,1
mov bh,0
mov bl,01100001B
mov dh,07h
mov dl,10h
mov bp,str2
mov cx,str2_length
int 10h

mov ah,13h
mov al,1
mov bh,0
mov bl,01100001B
mov dh,09h
mov dl,10h
mov bp,str3
mov cx,str3_length
int 10h

Listen_in:
	mov ah,0	;提示用户输入后，监听,输入存于al中
	int 16h

	cmp al,0dh	;判断输入的是否是回车键,ASC码的十六进制是0d
	jne Shownum	;jne,如果不是回车键，跳转到shounum函数显示用户输入的数字并储存
	jmp Run_pro;如果是回车键，跳转到Run_pro函数执行输入序列的程序

Run_pro:
	cmp word [a],0 ;第一个程序
	jne proa
	jmp Run_end	;没有则结束
	proa:
	mov ax,[a]
	sub ax,46	;扇区偏移，前两个扇区中分别放着引导和操作系统,[a]-48+2=[a]-46 
	mov [position],ax	;用户程序的加载扇区位置
	call Run
	
	cmp word [b],0 ;第二个程序
	jne prob
	jmp Run_end
	prob:
	mov ax,[b]
	sub ax,46	
	mov [position],ax	
	call Run

	cmp word [c],0 ;第三个程序
	jne proc
	jmp Run_end
	proc:
	mov ax,[c]
	sub ax,46	
	mov word [position],ax
	call Run
	
	cmp word [d],0 ;第四个程序
	jne prod
	jmp Run_end
	prod:
	mov ax,[d]
	sub ax,46	
	mov word [position],ax
	call Run
	
Run_end:

	jmp	OS_start;所有程序执行完毕返回操作系统主界面
	

jmp $		

;=========显示输入的数字序列===========
Shownum:			
	mov ah,0eh
	mov bl,00h

	inc word [count]	;统计输入的数字序列的数字个数，每次跳转到shownum函数,count加1
	cmp word [count],1
	je savea
	jmp compB
	savea:
	mov [a],al		;用户输入的数字存储在al中，将输入的数字存在a中
	int 10h
	je Listen_in

	compB:
	cmp word [count],2	
	je saveb
	jmp compC
	saveb:
	mov [b],al
	int 10h
	je Listen_in

	compC:
	cmp word [count],3
	je savec
	jmp compD
	savec:
	mov [c],al		
	int 10h			
	je Listen_in
	
	compD:
	cmp word [count],4
	je saved
	jmp compE
	saved:
	mov [d],al		
	int 10h			;Shownum
	je Listen_in
	
	compE:
	cmp word [count],5 ;超过四个字符不显示也不保存，继续监听直到回车
	jge Listen_in ;如果大于或等于5则跳转

;==============执行选择的用户程序===============
Run:				;执行某个用户的程序,具体扇区在[position] 中
	mov ax,0
	mov es,ax
	mov bx,0a700h  ;加载到内存e000
	mov ax,0201h;
	mov dx,0
	mov ch,0
	mov cl,[position];要被加载的扇区号
	int 13h;加载
	
	call word 0a700h 		
	ret
;============使屏幕显示为棕色===========
clean_s:               
	mov ax,0b800h
	mov es,ax
	mov ax,00
	mov cx,3999
	mov bx,00

	loop:
	mov byte [es:bx],' '
	inc bx
	mov byte [es:bx],01100001B; 棕色底
	inc bx
	cmp bx,cx
	jle loop
    ret

;=======初始化所有自定义的变量为0=====
inition:
	mov ax,0
	mov [count],ax
	mov [a],ax
	mov [b],ax
	mov [c],ax
	mov [position],ax
	ret

;===========字符串内容==============
str1:
	db 'Welcome to Ren Wendi OS.'
str1_length equ $-str1 

str2:
	db 'There are 4 user programs,you can choose any order to Run.'
str2_length equ $-str2

str3:
	db 'Input the number as examples:132/12/1342: '
str3_length equ $-str3
;================自定义数据====================
	var:		;程序所用到的一些临时变量
	count dd 0
	a dd 0
	b dd 0
	c dd 0
	d dd 0 
	position dd 0
	
times 512-($-$$) db 0	;扇区剩余位置填充0




