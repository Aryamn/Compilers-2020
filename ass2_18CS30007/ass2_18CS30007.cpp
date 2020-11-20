#include "toylib.h"
//function to print string in upper case
int printStringUpper(char* ch)
{
	int i=0,bytes;
	char buff[1000];

	while(ch[i]!='\0')
	{
		if(ch[i]<='z' && ch[i]>='a')	//if character is in smaller case convert into upper case
			buff[i] = ch[i]+('A'-'a');

		else
			buff[i] = ch[i];			//else remain same

		i++;
	}

	bytes = i;
	i=0;

	__asm__ __volatile__(				//extended assembly code to invoke syswrite function
		"movl $1, %%eax \n\t"
		"movq $1, %%rdi \n\t"
		"syscall \n\t"
		:
		:"S"(buff),"d"(bytes)
	);

	return bytes;						//returning length of characters printed
}

//Helper function to print integer part
int printInt(int n)
{
	char ze[2]="0";
	if(n==0)
	{	printStringUpper(ze);			// if n=0 then print 0
		return 1;
	}

	char buff[32];
	int i=0,j,k,bytes;

	if(n<0)								//if n is negative append "-" sign
	{
		buff[i++] = '-';
		n = -n;
	}

	while(n)							// store n in buffer array
	{
		int rem = n%10;
		buff[i++] = (char)(rem+'0');
		n/=10;
	}

	if(buff[0] == '-')
		j=1;
	else
		j=0;
	k = i-1;

	while(j<k)							//Code block to reverse buffer array
	{
		char temp = buff[j];
		buff[j++] = buff[k];
		buff[k--] = temp;
	}
	buff[i] = '\0';						//terminating character at the end 
	bytes = i;
	printStringUpper(buff);
	return bytes;						//returning length of characters printed
}

//Function to print floating point number
int printFloat(float f)
{
	int ipart = (int)f;					//Extracting integer part
	int i=1,len=5;
	float fpart = f-(float)ipart;		//Extracting floating part
	char fpartstr[30];
	char neg[2]="-";

	if(ipart==0 && f<0)printStringUpper(neg);
	len += printInt(ipart);				//Printing integer part and adding its length

	if(fpart<0) fpart=-fpart;
	fpartstr[0]='.';

	while(fpart>0 && i<=4)				//storing floating part till 6 decimal places
	{
		fpart*=10;
		ipart = (int)fpart;
		fpartstr[i++] = ipart+'0';
		fpart = fpart-ipart;
	}

	while(i<=4)							//append zeroes if not till 6 places
		fpartstr[i++]='0';

	fpartstr[i] = '\0';					//terminating character at the end
	printStringUpper(fpartstr);			//Printing flaoting part
	return (len+i);						//returning number of characters printed
}

//Function to print hexadecimal numbers
int printHexInteger(int n)
{
	char buff[30];
	int i=0,j,k,bytes;
	char ze[2]="0";
	if(n==0)							//if n=0 then print 0
	{	printStringUpper(ze);
		return 1;
	}

	if(n<0)								//if n is negative store "-"sign 
	{
		buff[i++]='-';
		n=-n;
	}

	while(n)							//converting integer to hexadecimal and storing it
	{
		int rem = n%16;

		if(rem<=9)
			buff[i++] = (char)(rem+'0');

		else
			buff[i++] = (char)((rem-10)+('A'));

		n/=16;
	}

	if(buff[0] == '-')
		j=1;
	else
		j=0;
	k = i-1;

	while(j<k)							//Codeblock to reverse the buffer array
	{
		char temp = buff[j];
		buff[j++] = buff[k];
		buff[k--] = temp;
	}
	buff[i] = '\0';						//terminating character at the end
	bytes = i;
	printStringUpper(buff);
	return bytes;						//returning length of characters printed
}

//Function to read floating point numbers
int readFloat(float *f)
{
	char buff[101];
	int charsread;
	int i,inte=0,flag=0,f2=0;
	float fac=0.1,dec=0,ans;

	__asm__ __volatile__(				//extended assembly code to invoke sysread function
		"syscall"
		: "=a"(charsread)
		: "a"(0),"D"(0),"S"(buff),"d"(sizeof(buff))
		: "rcx","r11","memory","cc"
	);

	buff[--charsread] = '0';
	i = charsread-1;

	while(i>=0 && buff[i--]==' ');		//remove trailing spaces
	buff[i+2] = '0';
	charsread = i+2;
	i = -1;
	while(buff[++i]==' ');				//removing leading spaces

	if(buff[i]=='-')					//flag=1 if number is negative
	{
		i++;
		flag=1;
	}

	if(buff[i]>='0' && buff[i]<='9')	//checking if first character is valid
	{	
		inte = buff[i]-'0';
		i++;
	}

	else if(buff[i]=='.')
	{
		f2=1;
		i++;
	}

	else return BAD;					//else return BAD

	for(;i<charsread;i++)
	{
		if(buff[i]=='.' && f2==1)		//if encounter second decimal return BAD
			return BAD;
		if(buff[i]=='.')
		{	
			f2=1;
			continue;
		}

		else if(!(buff[i]>='0' && buff[i]<='9'))return BAD; //If not a valid chracter return BAD
		else if(f2)						//calculating decimal part
		{
			dec = dec + fac*(buff[i]-'0');
			fac = fac*0.1;
		}

		else							//calculating integer part
		{
			inte = inte*10 + (buff[i]-'0');
		}
	}

	ans = inte+dec;						//adding integer and decimal part
	if(flag) ans = -ans;
	*f = ans;							
	return GOOD;						//returning GOOD if it is a valid number
}

int readHexInteger(int *n)
{
	char buff[101];
	int charsread;
	int i,inte=0,flag=0;
	int ans;

	__asm__ __volatile__(				//extended assembly code to invoke sysread function
		"syscall"
		: "=a"(charsread)
		: "a"(0),"D"(0),"S"(buff),"d"(sizeof(buff))
		: "rcx","r11","memory","cc"
	);

	buff[--charsread] = '0';
	i = charsread-1;
	while(i>=0 && buff[i--]==' ');		//remove trailing spaces
	buff[i+2] = '0';
	charsread = i+2;
	i = -1;
	while(buff[++i]==' ');				//remove leading spaces

	if(buff[i]=='-')					//flag=1 if number is negative
	{
		i++;
		flag=1;
	}

	if(buff[i]>='0' && buff[i]<='9')	//checking if first character is valid
	{	
		inte = buff[i]-'0';
		i++;
	}

	else if(buff[i]>='A' && buff[i]<='F')
	{
		inte = (buff[i]-'A')+10;
		i++;
	}

	else return BAD;					//else return BAD

	for(;i<charsread;i++)
	{
		
		if(buff[i]>='0' && buff[i]<='9')	//checking if character are valid as hex
			inte = inte*16+(buff[i]-'0');

		else if(buff[i]>='A' && buff[i]<='F')
			inte = inte*16 + (buff[i]-'A') + 10;

		else
			return BAD;					//else return BAD
	}

	ans = inte;
	if(flag) ans = -ans;				
	*n = ans;
	return GOOD;						//returning GOOD if given hexadecimal is valid
}