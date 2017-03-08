	org 100h 		; 告诉编译器程序加载到100H处

	RootDirSectors	equ	14		; 根目录占用的扇区数
	SectorNoOfRootDirectory	equ	19	; 根目录区的首扇区号

	mov ax,cs		; 置 DS和ES=CS（须经AX中转）
	mov ds,ax
	mov es,ax
	mov	ss,ax	; 堆栈段
	mov	sp,100h ; 堆栈基址
	call ScrollPg	; 调用清屏例程
	
	
	; 下面在磁盘根目录中寻找文件目录条目
	mov	word [isec], SectorNoOfRootDirectory 	; 给表示当前扇区号的
						; 变量wSectorNo赋初值为根目录区的首扇区号（=19）
begain: 
	; 下面在磁盘根目录中寻找文件目录条目
searchrdir: ; 搜索根目录循环（逐个读入根目录扇区）
	cmp	word [nsec], 0	; 判断根目录区是否已读完
	jz	exit			; 若读完则退出
	dec	word [nsec]		; nsec--
	; 调用读扇区函数读入一个根目录扇区到缓冲区
	mov	bx, Sector		; BX = Sector
	mov	ax, [isec]		; AX <- 根目录中的当前扇区号
	mov cl, 1			; 读一个扇区到缓冲区
	call ReadSec		; 调用读扇区函数
	
	mov	di, Sector		; ES:DI -> Sector	
	mov	word [i], 10h	; 循环次数=16（每个扇区有16个文件条目：512/32=16）
searchfi: ; 搜索文件项循环（在当前扇区中逐个检查文件目录项）
	cmp	word [i], 0		; 循环次数控制
	jz nextsec 			; 若已读完一扇区，跳到下一扇区
	dec	word [i]		; 递减循环次数值
	; 判断是否为文件条目（0开始的为空项、E5h开始的为已删项、属性低4位全1的
	; 为长文件名项或系统占用项、卷标项的属性3号位为1）
	cmp	byte [di], 0	; 文件名的首字母=0？
	jz	notfi			; 为空目录项
	cmp	byte [di], 0E5h	; 文件名的首字母=E5？
	jz	notfi 			; 为已删除目录项
	cmp	byte [di + 11], 0Fh; 文件属性=0Fh？
	jz	notfi 			; 为长文件名目录项

	; 显示文件名串
	push dx
	mov dh,[lns]
	mov dl,0
	mov cx,11		; 串长=11
	; 显示文件条目信息（文件名、大小、时间）
	; 显示文件名串
	mov bp, di			; BP=文件名字符串的起始地址
	call DispStr		; 调用显示字符串例程
	

	inc word [lns]		; 当前屏幕上的文件条目数lns++
    pop dx
    
notfi:
	add	di, 20h			; DI += 20h 指向下一个目录条目开始处
	jmp	searchfi		; 转到循环开始处

nextsec:
	inc	word [isec] 	; 递增当前扇区号
	jmp	searchrdir		; 继续搜索根目录循环

exit: ; 终止程序，返回
	mov ax,4c00h
	int 21h

	;变量
BPB_SecPerTrk   dw 18	; 每磁道扇区数
BS_DrvNum		db 0		; 中断13h的驱动器号（对软盘B应该为1）
nsec dw	RootDirSectors	; 根目录区剩余扇区数
										;初始化为14，在循环中会递减至零
isec dw	0	; 当前扇区号，初始化为0，在循环中会递增
lns db 0	; 定义显示行号，初值为0
i dw 0
heads dw 2
drvno dw 0
secspt dw 18

Sector: ; 定义缓冲区，用于存放从磁盘读入的扇区
	resb 512

;----------------------------------------------------------------------------
; 函数名：ReadSector
;----------------------------------------------------------------------------
; 作用：从第 AX个扇区开始，将1个扇区读入ES:BX中
ReadSec:
	; -----------------------------------------------------------------------
	; 怎样由扇区号求扇区在磁盘中的位置 (扇区号->柱面号、起始扇区、磁头号)
	; -----------------------------------------------------------------------
	; 设扇区号为 x
	;                           ┌ 柱面号 = y >> 1
	;       x           ┌ 商 y ┤
	;   -------------- 	=> ┤      └ 磁头号 = y & 1
	;  每磁道扇区数     │
	;                   └ 余 z => 起始扇区号 = z + 1
		push cx			; 保存要读的扇区数CL
	push bx			; 保存BX
	mov	bl, [secspt]; BL(= 磁道扇区数）为除数
	div	bl			; AX/BL，商y在AL中、余数z在AH中
	inc	ah			; z ++（因磁盘的起始扇区号为1），AH = 起始扇区号
	mov	cl, ah		; CL <- 起始扇区号S
	mov	ah, 0		; AX <- y
	mov bl, [heads]	; BL(= 磁头数）为除数
	div	bl			; AX/BL，商在AL中、余数在AH中
	mov	ch, al		; CH <- 柱面号C
	mov	dh, ah		; DH <- 磁头号H
	; 至此，"柱面号、起始扇区、磁头号"已全部得到
	pop	bx			; 恢复BX
	pop ax			; AL = 恢复的要读的扇区数CL
	mov	dl, [drvno]	; 驱动器号
.1: ; 使用磁盘中断读入扇区
	mov	ah, 2		; 功能号（读扇区）
	int	13h			; 磁盘中断
	jc .1			; 如果读取错误，CF会被置为1，这时就不停地读，直到正确为止
	ret
;----------------------------------------------------------------------------

ScrollPg: ; 清屏例程
	mov	ah, 6			; 功能号
	mov	al, 0			; 滚动的文本行数（0=整个窗口）
	mov bh,0fh		; 设置插入空行的字符颜色为黑底亮白字
	mov cx, 0			; 窗口左上角的行号=CH、列号=CL
	mov dh, 24		; 窗口右下角的行号
	mov dl, 79		; 窗口右下角的列号
	int 10h			; 显示中断
	ret

DispStr: ; 显示字符串例程（需先置行号dh和串地址BP）
	mov ah,13h 		; BIOS中断的功能号（显示字符串）
	mov al,1 			; 光标放到串尾
	mov bh,0 		; 页号=0
	mov bl,0fh 		; 字符颜色=不闪（0）黑底（000）亮白字（1111）
	int 10h 			; 调用10H号显示中断
	ret				; 从例程返回
