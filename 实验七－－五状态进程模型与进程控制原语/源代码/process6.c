#include "muti_process.h"

char str[ 80] = "129djwqhdsajd128dw9i39ie93i8494urjoiew98kdkd";
int LetterNr = 0;
void main() {
	__asm__( "sti");
	int pid;
	char ch;
	printf( "\r\n\r\nBefore fork \r\n");
	pid = fork();
	if ( pid == -1) printf( "error in fork!\0");
	if ( pid){
		printf( "\r\nFather process:after fork pid is :");
		printInt( pid);
		
		ch = wait();

		printf( "\r\n\r\nFather process:LetterNr=");
		ntos( LetterNr);
		exit(0);
	}
	else{
		printf( "\r\nChild process:after fork pid is :");
		printInt( pid);

		CountLetter( str);
		exit( 0);
	}
}


