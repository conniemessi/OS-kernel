__asm__(".code16gcc"); //将汇编嵌入GCC

//----------------os.asm supply---------------
extern void print_welcome_str();
extern void screen_init();
extern void print_message();
extern void printT(char);
extern void print_cmd();
extern void scroll_screen();
extern void cmd_scroll();
extern void cmd_scroll_up();
extern char input_char();
extern unsigned short int get_mouse_pos();
extern void set_mouse_pos();
extern void print_timeclock(char);
extern void interrupt_init();

//------------oslib.asm supply------------------
extern void clear();
//--------------osclibc supply-------------------
extern void print_str(const char *p , unsigned short int l);
extern char strcmp(const char *a, const char *b);
extern void time();
extern void date();

//----------------local---------------------------
char listen_key();

char key[64];
char screen_sc_T = 1;
//===================MAIN=======================
void main(){
	__asm__("movw $0,%ax");
	__asm__("movw %ax, %ss");	
	screen_init();
	interrupt_init();
	print_welcome_str();
	print_message();
	print_cmd(); //ren@ren-Inspiron:~   position
	while(1){
		char length = listen_key();

		unsigned short int now_row = get_mouse_pos()/256;
		if( now_row >23){			// 0~24   24 is deeplist line
			while( screen_sc_T--){
				scroll_screen();
				cmd_scroll_up();
			}
		}

		cmd_scroll();//move cmd to next line
		print_cmd();
	}
}

//====================MAIN END=======================

char listen_key(){
	char temp;
	char i=0;

	while(( temp=input_char())!=0x0d ){
		//delete a char
		if( temp == '\b'){				// delete a word
			unsigned short int now_pos = get_mouse_pos();
			if( (now_pos&0x00ff) <21){	//do not delete cmd
				continue;
			}
			printT('\b');
			printT(' ');
			printT('\b');
			i--;
			continue;
		}
		//end delete
		key[i] = temp;	
		//char key[64]		
		if(i<63)
		    i++;
		printT( temp);
		printTimeClock();
	}
	key[i] = '\0';
	screen_sc_T = 1;	
//------------------system command------------------------------
	if( strcmp( key, "clear\0")){			// char *,const char *
		clear();
		return i;
	}

	if( strcmp( key, "time\0")){
		time();
		return i;
	}

	if( strcmp( key, "date\0")){
		date();
		return i;
	}

//------------------run programs command----------------------
	if( synCheck( key, "run\0")){
		run( key);
		return i;
	}

	if( synCheck( key, "int\0")){
		if( strcmp( key, "int 33h")){
			__asm__(  "int $0x33");
			return i;
		}
		if( strcmp( key, "int 34h")){
			__asm__(  "int $0x34");
			return i;
		}
		if( strcmp( key, "int 35h")){
			__asm__(  "int $0x35");
			return i;
		}
		if( strcmp( key, "int 36h")){
			__asm__(  "int $0x36");
			return i;
		}
	}

	if( key[0] == '\0'){
		return i;
	}
	
	cmd_scroll();
	set_mouse_pos();
	print_str(" No such file or Directory", 26);
	screen_sc_T = 2;
	return i;
}


