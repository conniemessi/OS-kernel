__asm__(".code16gcc");

struct Tss{
	short int SS;
	short int GS;
	short int FS;
	short int ES;
	short int DS;
	short int CS;
	short int DI;
	short int SI;
	short int BP;
	short int SP;
	short int DX;
	short int CX;
	short int BX;
	short int AX;
	int IP;
	short int Flags;
};

struct pcb{
	struct Tss tss;
	int process_status; // 0 is ready , 1 is runing
	int process_id;
};

extern void screen_init();
extern void load_user( char, unsigned short int );
extern void saveall_reg();
extern void restore_reg();
extern void saveall_reg_seg();
extern void restore_reg_seg();
extern void init_flag_postion();
extern void print_welcome_msg();
extern void print_message();
extern void print_flag();

inline void sti(){
	__asm__("sti");
}

inline void cli(){
	__asm__("cli");
}


#define process_num_MAX  5
#define process_SEG  0
#define READY 0
#define RUNNING 1

int process_num = 5;		
int start_process_num = 1;

char isProcessRun = 0; 
struct pcb PCB_queue[ process_num_MAX +1 ];


short int w_is_r;
short int nw_is_r;
short int _cs,_flags;
int _ip;
short int _ax,_bx,_cx,_dx,_es,_ds,_sp,_bp,_si,_di,_fs,_gs,_ss;

inline void backto_os(){
	init_flag_position();	
	__asm__("pop %si");
	screen_init();
	__asm__("pop %si");
	print_welcome_msg();
	__asm__("pop %si");
	print_message();
	__asm__("pop %si");
	print_flag();
	__asm__("pop %si");
}

inline void saveToqueue(){
	PCB_queue[ w_is_r].tss.ES = _es;
	PCB_queue[ w_is_r].tss.DS = _ds;
	PCB_queue[ w_is_r].tss.GS = _gs;
	PCB_queue[ w_is_r].tss.FS = _fs;
	PCB_queue[ w_is_r].tss.SS = _ss;
								
	PCB_queue[ w_is_r].tss.AX = _ax;
	PCB_queue[ w_is_r].tss.BX = _bx;
	PCB_queue[ w_is_r].tss.CX = _cx;
	PCB_queue[ w_is_r].tss.DX = _dx;
	PCB_queue[ w_is_r].tss.SI = _si;
	PCB_queue[ w_is_r].tss.DI = _di;
	PCB_queue[ w_is_r].tss.BP = _bp;
}

inline void queueTodata(){
	_es = PCB_queue[ nw_is_r].tss.ES;
	_ds = PCB_queue[ nw_is_r].tss.DS;
	_gs = PCB_queue[ nw_is_r].tss.GS;
	_fs = PCB_queue[ nw_is_r].tss.FS;
	_ss = PCB_queue[ nw_is_r].tss.SS;
							   
	_ax = PCB_queue[ nw_is_r].tss.AX;
	_bx = PCB_queue[ nw_is_r].tss.BX;
	_cx = PCB_queue[ nw_is_r].tss.CX;
	_dx = PCB_queue[ nw_is_r].tss.DX;
	_si = PCB_queue[ nw_is_r].tss.SI;
	_di = PCB_queue[ nw_is_r].tss.DI;
	_bp = PCB_queue[ nw_is_r].tss.BP;
}


void init_pcb( int i, short int current_process_SEG){
	//tss
	PCB_queue[ i].tss.DS = 0; 
	PCB_queue[ i].tss.ES = current_process_SEG; 
	PCB_queue[ i].tss.FS = 0; 
	PCB_queue[ i].tss.CS = 0; 
	PCB_queue[ i].tss.SS = 0; 
	PCB_queue[ i].tss.GS = 0; 
	PCB_queue[ i].tss.DI = 0; 
	PCB_queue[ i].tss.SI = 0; 
	PCB_queue[ i].tss.SP = current_process_SEG-4; 
	PCB_queue[ i].tss.BP = 0; 
	PCB_queue[ i].tss.AX = 0; 
	PCB_queue[ i].tss.BX = 0; 
	PCB_queue[ i].tss.CX = 0; 
	PCB_queue[ i].tss.DX = 0; 
	PCB_queue[ i].tss.IP = current_process_SEG;		//cs;ip 
	PCB_queue[ i].tss.Flags = 512;  
	PCB_queue[ i].process_id = i; 
	PCB_queue[ i].process_status = READY; 
}

int fin_times = 0;
void schedule(){
	saveall_reg();			//note: not inclue sp
	__asm__("pop %cx");
	__asm__("pop %eax");	

	nw_is_r = w_is_r + 1;
	if( nw_is_r > process_num_MAX){
		nw_is_r = RUNNING;	
	}

	
	saveToqueue();			//code order don't change	


	//----------------set ip cs flag--------
	__asm__("pop %ax");
	__asm__("pop %bx");
	__asm__("pop %cx");

	saveall_reg_seg();		//include sp
	__asm__("pop %cx");

	if( _di == 0x1234){	
		isProcessRun = 0;			//shut down process
		nw_is_r = READY;
		backto_os();
	}else{
		isProcessRun = 1;
	}


	PCB_queue[ w_is_r].tss.SP = _sp;
	PCB_queue[ w_is_r].tss.IP = _ip;
	PCB_queue[ w_is_r].tss.CS = _cs;
	PCB_queue[ w_is_r].tss.Flags = _flags;

		//-----------------end------------------
	_ip = PCB_queue[ nw_is_r].tss.IP;
	_cs = PCB_queue[ nw_is_r].tss.CS;
	_flags = PCB_queue[ nw_is_r].tss.Flags;
	_sp = PCB_queue[ nw_is_r].tss.SP;

	restore_reg_seg();
	__asm__("pop %cx");


	queueTodata();		// ax bx cx...
	
	w_is_r++;
	if( w_is_r > process_num_MAX){
		w_is_r = RUNNING;
	}

	restore_reg();	
	__asm__("pop %di");		//don't use di in any process is dangerous

	__asm__("jmp schedule_end");
	while(1);
}


void Process(){
	int current_process_SEG = process_SEG;
	int i;
	for( i = start_process_num; i <= process_num; i++){
		current_process_SEG = i*0x0800;
		init_pcb( i, current_process_SEG);
	}

	load_user( 1, 0x0800);
	__asm__(" pop %cx");
	load_user( 2, 0x1000);
	__asm__(" pop %cx");
	load_user( 3, 0x1800);
	__asm__(" pop %cx");
	load_user( 4, 0x2000);
	__asm__(" pop %cx");
	load_user( 5, 0x2800);		//wait key
	__asm__(" pop %cx");
	// 4000- sub stack 

	w_is_r = READY;
	isProcessRun=1; // enter user process mode
}



