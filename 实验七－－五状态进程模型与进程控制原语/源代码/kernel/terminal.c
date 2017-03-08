#include "terminal.h"

char key[64];
char screen_sc_T = 1;
char flag_len=20; 
char Print_flag_mark = 1;

//--------------------local function-------------------
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

//---------------------------------mark: man xxx, run xxx,asc xx...

	
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
	print_str(" No such file or directory", 26);
	screen_sc_T = 2;
	return i;
}



