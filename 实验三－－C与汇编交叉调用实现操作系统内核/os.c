__asm__(".code16gcc"); //将汇编嵌入GCC

//-------------------------os.asm supply-----
extern void print_welcome_str();
extern void screen_init();
extern void print_message();
extern void printT( char);
extern void print_flag();
extern void scroll_screen();
extern void flag_scroll();
extern void init_ss();
extern void flag_scroll_up();
extern char input_char();
extern unsigned short int get_pointer_pos();
extern void set_pointer_pos();
extern void print_corner( char);


//-------------------------oslib.asm supply-----
extern void clear();
//------------------------osclibc supply-----
extern inline void print_str( const char *p , unsigned short int l);
extern char strcmp(const char *a, const char *b);
extern inline void time ();
extern inline void date ();

//--------------------------local-------
inline char listen_key();

char key[64];
char screen_sc_T = 1;
//============================+MAIN==============
void main(){
	init_ss();
	screen_init();
	print_welcome_str();
	print_message();
	print_flag(); //renwendi@:   position
	while(1){
		char length = listen_key();

		unsigned short int now_row = get_pointer_pos()/256;
		if( now_row >23){			// 0~24   24 is deeplist line
			while( screen_sc_T--){
				scroll_screen();
				flag_scroll_up();
			}
		}

		flag_scroll();//move flag to next line
		print_flag();
	}
}

//============================MAIN END===============

inline char listen_key(){
	char temp;
	char i=0;
//	unsigned short int init_pos = get_pointer_pos();
	while(( temp=input_char())!=0x0d ){
		if( temp == '\b'){				// delete a word
			unsigned short int now_pos = get_pointer_pos();
			if( (now_pos&0x00ff) <21){	//do not delete flag
				continue;
			}
			printT('\b');
			printT(' ');
			printT('\b');
			i--;
			continue;
		}
		key[i] = temp;	
		if(i<63)i++;
		printT( temp);
	}
	key[i] = '\0';
	screen_sc_T = 1;
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


	if( synCheck( key, "run\0")){
		run( key);
		return i;
	}

	if( key[0] == '\0'){
		return i;
	}
	
	flag_scroll();
	set_pointer_pos();
	print_str("  No such file or Directory", 27);
	screen_sc_T = 2;
	return i;
}




