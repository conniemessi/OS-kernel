org 0x1000	

int 33h
int 34h
int 35h
int 36h


;LISTEN_EXIT----
listen:
	mov ch,'A'
	cmp ch,cl
jne listen 

ret

times 512-($-$$) db 0	;填充剩余扇区0


