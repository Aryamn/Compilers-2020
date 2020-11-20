#include<iostream>
using namespace std;
#include "toylib.h"

int main()
{
	int n;
	float f;
	int x;
	char ip[13]="enter input\n";
	char ip2[14]="enter choice\n";
	char ip3[19]="\nEnter HexInteger\n";
	char ip4[15]="Invalid input\n";
	char ip5[13]="valid input\n";
	char ip6[14]="\nEnter float\n";
	char ip7[2]="\n";
	printStringUpper(ip);
	while(1)
	{
		cout<<"\ninput 1 for readHexInteger\n";
		cout<<"\ninput 2 for readFloat\n";
		cout<<"\ninput 3 for printHexInteger\n";
		cout<<"\ninput 4 for printFloat\n";
		cout<<"\ninput 0 to exit\n";

		printStringUpper(ip2);
		cin>>n;
		if(n==0)
			break;
		else
		{
			switch(n)
			{
				case 1:

				printStringUpper(ip3);

				if(readHexInteger(&x)==BAD)
					printStringUpper(ip4);
				else
					printStringUpper(ip5);
				break;

				case 2:
				printStringUpper(ip6);

				if(readFloat(&f)==BAD)
					printStringUpper(ip4);
				else
					printStringUpper(ip5);
				break;

				case 3:
				printHexInteger(x);
				printStringUpper(ip7);
				break;

				case 4:
				printFloat(f);
				printStringUpper(ip7);
				break;

			}
		}
	}

	return 0;
}
