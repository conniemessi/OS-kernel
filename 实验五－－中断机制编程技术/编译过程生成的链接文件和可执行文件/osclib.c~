__asm__(".code16gcc");
extern void printT( char);
extern void screen_init();
extern void init_cmd_position();
extern void cmd_scroll();
extern void set_mouse_pos();
extern void clear();
extern void cmd_scroll_up();
extern unsigned short int get_time();
extern unsigned short int get_second();

extern unsigned short int get_year();		
extern unsigned short int get_date();	
extern void load_user( unsigned short int); 
extern void run_user(); 

extern char screen_sc_T; 

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
char strlen( char*p){
	char i=0;
	while(*p!='\0'){
		p++;
		i++;
	}
	return i;
}

void print_str( const char *p , unsigned short int l){
	while(l>0){
		printT( *p);
		p++;
		l--;
	}
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

char str[10];

void time(){
	unsigned short int now_row = get_mouse_pos()/256;
		
	cmd_scroll();
	set_mouse_pos();
	screen_sc_T = 2;

	unsigned short int h_m,second;
    char h, m, sec, ds;
	h_m = get_time();
	second = get_second();

    h = (h_m & 0xff00) >> 8;
    m = h_m & 0xff;
    sec = (second & 0xff00) >> 8;

    print_str(" Now time is: ", 15);
    printT(((h & 0xf0) >> 4) + '0');
    printT((h & 0xf) + '0');
    printT(':');
    printT(((m & 0xf0) >> 4) + '0');
    printT((m & 0xf) + '0');
    printT(':');
    printT(((sec & 0xf0) >> 4) + '0');
    printT((sec & 0xf) + '0');
}

void date(){

	cmd_scroll();
	set_mouse_pos();
	screen_sc_T = 2;


	unsigned short int year,m_d;
	year = get_year();
	m_d = get_date();

    print_str(" Now Date is: ", 15);
   	printT(((year & 0xf000) >> 12) + '0');
	printT(((year & 0xf00) >> 8) + '0');
	printT(((year & 0xf0) >> 4) + '0');
	printT((year & 0xf) + '0');
	printT('-');
	printT(((m_d & 0xf000) >> 12) + '0');
	printT(((m_d & 0xf00) >> 8) + '0');
	printT('-');
	printT(((m_d & 0xf0) >> 4) + '0');
	printT((m_d & 0xf) + '0');
	
}

char synCheck( char * str, const char * dst){		//str is key
	char pos = strpos( str, ' ');		//pos is ' ' position
	if(pos == '\0'){
		return 0;
	}

	char *prompt = strcpy( str, 0, pos );	//pos is times

	if( !strcmp( prompt, dst)){
		return 0;	
	}

	if( strcmp( prompt, "int")){				
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
void run_error(){
	cmd_scroll();
	set_mouse_pos();
	screen_sc_T = 2;
	char *p = " Run error.Note: each num should be 0<x<5";
	print_str( p, strlen( p));
}

void run( char *str){
	
	while( *str != '\0'){
		if('0'<*str && *str<'6'){
			load_user( *str-'0'+14);	//in oslib.asm	
			run_user();
			init_cmd_position();	
			screen_init();
			print_welcome_str();
			print_message();
			print_cmd(); 

			}else{
				run_error();
			}
		str++;
	}
}



