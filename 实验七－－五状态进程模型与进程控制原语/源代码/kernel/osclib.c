__asm__(".code16gcc");
extern void printToscn( char);
extern void init_flag_position();
extern void flag_scroll();
extern void set_pointer_pos();
extern void clear();
extern void flag_scroll_up();
extern unsigned short int get_time();		
extern unsigned short int get_second();

extern unsigned short int get_year();		
extern unsigned short int get_date();		
extern void load_user( char, unsigned short int );
extern void run_user(); 
extern void init_ss();
extern char screen_sc_T; 
extern char flag_len; 
extern char * key; 
extern void Schedule();

//ing
char * itoa( short int);



//---------------------------------------------------
char ans[20];
char * strcpy( char *p, char src,char len){
	char i =1;
	p+=src;
	while(*p!='\0'&&i<=len){
		ans[ i-1]	= *p;
		i++;
		p++;
	}	
	return ans;
}

void if_screen_scroll(){
	unsigned short int now_row = get_pointer_pos()/256;
	__asm__("pop %si");
	if( now_row >23){			// 0~24   24 is deeplist line
		while( screen_sc_T--){
			scroll_screen();
			__asm__("pop %si");
			flag_scroll_up();
			__asm__("pop %si");
		}
	}
}

char strpos( char*p, const char dst){
	char i=0;
	while(*p!='\0'){
		if(*p==' '){
			return i;
		}
		p++;
		i++;
	}
	return '\0';
}


char strcmp( char *a, const char *b){
	while( (*a!='\0')&& (*b!='\0')&& (*b==*a)){
		b++;
		a++;
	}
	if( *a==*b){
		return 1;
	}else{
		return 0;
	}
}



void time(){
	unsigned short int now_row = get_pointer_pos()/256;
	flag_scroll();
	__asm__("pop %si");
	set_pointer_pos();
	__asm__("pop %si");
	screen_sc_T = 2;

	unsigned short int h_m,second;
    char h, m, sec, ds;
	h_m = get_time();
	__asm__("pop %si");
	second = get_second();
	__asm__("pop %si");

    h = (h_m & 0xff00) >> 8;
    m = h_m & 0xff;
    sec = (second & 0xff00) >> 8;

    print_str(" Now time is: ", 15);
    printToscn(((h & 0xf0) >> 4) + '0');
	__asm__("pop %si");
    printToscn((h & 0xf) + '0');
	__asm__("pop %si");
    printToscn(':');
	__asm__("pop %si");
    printToscn(((m & 0xf0) >> 4) + '0');
	__asm__("pop %si");
    printToscn((m & 0xf) + '0');
	__asm__("pop %si");
    printToscn(':');
	__asm__("pop %si");
    printToscn(((sec & 0xf0) >> 4) + '0');
	__asm__("pop %si");
    printToscn((sec & 0xf) + '0');
	__asm__("pop %si");
}

void date(){
	flag_scroll();
	__asm__("pop %si");
	set_pointer_pos();
	__asm__("pop %si");
	screen_sc_T = 2;


	unsigned short int year,m_d;
	year = get_year();
	__asm__("pop %si");
	m_d = get_date();
	__asm__("pop %si");

    print_str(" Now Date is: ", 15);
   	printToscn(((year & 0xf000) >> 12) + '0');
	__asm__("pop %si");
	printToscn(((year & 0xf00) >> 8) + '0');
	__asm__("pop %si");
	printToscn(((year & 0xf0) >> 4) + '0');
	__asm__("pop %si");
	printToscn((year & 0xf) + '0');
	__asm__("pop %si");
	printToscn(' ');
	__asm__("pop %si");
	printToscn(((m_d & 0xf000) >> 12) + '0');
	__asm__("pop %si");
	printToscn(((m_d & 0xf00) >> 8) + '0');
	__asm__("pop %si");
	printToscn('-');
	__asm__("pop %si");
	printToscn(((m_d & 0xf0) >> 4) + '0');
	__asm__("pop %si");
	printToscn((m_d & 0xf) + '0');
	__asm__("pop %si");
	
}


char synCheck( char * str, const char * dst){		
	char pos = strpos( str, ' ');		
	if(pos == '\0'){
		return 0;
	}

	char *prompt = strcpy( str, 0, pos );	
	if( !strcmp( prompt, dst)){
		return 0;	
	}

	if( strcmp( prompt, "int")){				//check man
		if( !strcmp( str, "int 33h\0")&&
			!strcmp( str, "int 34h\0")&&
			!strcmp( str, "int 35h\0")&&
			!strcmp( str, "int 36h\0")
			){
			return 0;
		}
	}

	return 1;
}


extern char Usr_num;
void run_error(){
	flag_scroll();
	__asm__("pop %si");
	set_pointer_pos();
	__asm__("pop %si");
	screen_sc_T = 2;
	char *p = " Run error.Note: each num should be 0<x<3";
	print_str( p, strlen( p));
	printToscn( Usr_num);
}


//-------------------------------atoi

unsigned short int atoi( char * str_atoi){
	char i_syscall=0;
	short int sum_syscall_ai=0;
	
	while( str_atoi[i_syscall]!='\0'){
		sum_syscall_ai *= 10;
		sum_syscall_ai += (str_atoi[ i_syscall] - '0');
		i_syscall++;
	}
	return sum_syscall_ai;
}



//-------------------------------itoa
//itoa function in osclib_share.c



