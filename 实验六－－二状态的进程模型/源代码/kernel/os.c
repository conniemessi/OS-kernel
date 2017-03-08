__asm__(".code16gcc");

//-------------------------------------------------
extern char gets( char *);
extern char strcmp( char *, const char *);
extern void clear();
extern void time();
extern void date();
extern void run( char *);

extern void Process();

extern void flag_scroll();
extern void set_pointer_pos();
extern void clear();
extern void init_flag_position();
extern void printToscn( char);
extern void print_message();
extern void print_welcome_msg();
//--------------------------------------------------
extern void interrupt_init();
extern void print_flag();
extern void loader_user( char , unsigned short int);


extern char Print_flag_mark;
char Usr_num = '3';

inline void run( char *str){
	str += 4;
	
	while( *str != '\0'){
		if('0'<*str && *str< Usr_num){
		
				load_user( 5 + *str-'0', 0x1000);
				__asm__(" pop %ax");

				run_user();
				__asm__(" pop %ax");
				
		}else{
			run_error();
			return;
		}
		str++;
	}
	init_flag_position();	
	screen_init();
	print_welcome_msg();
	print_message();
	print_flag(); 
}
//------------------terminal-------------------------
char key[64];
char screen_sc_T = 1;
char flag_len=20; 
char Print_flag_mark = 1;

//--------------------------------- os.c---------
char listen_key(){
	flag_len=20;
	char i = gets( key);
	screen_sc_T = 1;
	Print_flag_mark = 1;
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
	
	if( strcmp( key, "start\0")){
		clear();
		set_pointer_pos();
		Print_flag_mark = 0;
		Process();
		return i;
	}

//---------------------------------

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
	
	flag_scroll();
	set_pointer_pos();
	print_str(" No such file or Directory", 26);
	screen_sc_T = 2;
	return i;
}


//============================+MAIN==============
void main(){
	//--------------------init
	screen_init();
	__asm__("pop %si");
	interrupt_init();
	__asm__("pop %si");
	print_welcome_msg();
	__asm__("pop %si");
	print_message();
	__asm__("pop %si");
	print_flag(); 
	__asm__("pop %si");
	//--------------------init_end
	while(1){
		char length = listen_key();

		if_screen_scroll(); //bottom of screen	
		flag_scroll();//move flag to next line
		__asm__("pop %si");
		if( Print_flag_mark)
			print_flag();
		__asm__("pop %si");
	}
}

//============================MAIN END===============


