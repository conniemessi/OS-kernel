org  7c00h		  
OffSetOfUserPrg equ 7e00h
Start:
	mov	ax, cs	       
	mov	ds, ax	        		 
	mov	ax, ds		  
	mov	es, ax	
	  
	mov	ax, 1301h		  
	mov	bx, 0047h		 
    mov dh, 8		 
	mov	dl, 28   
	mov	cx, str1_len  
	mov	bp, str1
	int	10h			   
     
    mov ax, 1301h
    mov bx, 0007h
    mov dh, 12
    mov dl, 20
    mov cx, str2_len
    mov bp, str2
    int 10h
	
    mov ah, 0	;用户监听，输入任何键后跳转进入操作系统主界面
    int 16h
	
LoadnEx:  
    xor ax,ax
    mov es,ax              
    mov bx, OffSetOfUserPrg      
    mov ax, 0235h                
    mov dl,0                  
    mov dh,0                
    mov ch,0                  
    mov cl,2                  
    int 13H                  
    jmp OffSetOfUserPrg   

AfterRun:
      jmp $   
	  
;===========字符串内容=============
str1   db 'Hello OS World!'
str1_len  equ ($-str1)
str2  db 'Please press any key to continue '
str2_len  equ ($-str2)

times 510-($-$$) db 0
db 0x55,0xaa

