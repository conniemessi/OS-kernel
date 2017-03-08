[bits 16]
extern main		;forbid run this file any time
jmp main

global syscall_init,run_syscall
extern syscall_num
extern do_fork, do_wait, do_exit

setting_up_syscall:
	mov bx,0
	mov es,bx
	mov al,ah
	mov ah,0
	shl al,2
	mov bx,0xfe00
	add bx,ax
	mov [es:bx],ecx
ret

syscall_init:

;----#1 syscall(wait)
	mov ah,1
	mov ecx,0
	mov cx,do_wait
	call setting_up_syscall
	
;----#2 syscall(fork)
	mov ah,2
	mov ecx,0
	mov cx,do_fork
	call setting_up_syscall

;----#3 syscall(exit)
	mov ah,3
	mov ecx,0
	mov cx,do_exit
	call setting_up_syscall

ret



run_syscall:
	cli
	mov ax,0
	mov es,ax
	mov al,[ syscall_num]
	shl ax,2
	mov bx,0xfe00
	add bx,ax
	call [ es:bx]
	sti
ret

