/* Test File 1
	Archit Agarwal & Aryaman Jain
*/

//Arithmetic Operations

int printStr(char *s);
int printInt(int n);
int readInt(int *x);

int main()
{
    int a,b,c,d,e,f;

    printStr("Enter first Integer : \n");
    readInt(&a);
    printStr("Enter Second Integer : \n");
    readInt(&b);

    c = a+b;
    d = a-b;
    e = a*b;
    f = a/b;

    printStr("The following Arithmetic Operations are : \n");
    printInt(a);
    printStr("+");
    printInt(b);
    printStr("=");
    printInt(c);
    printStr("\n");

    printInt(a);
    printStr("-");
    printInt(b);
    printStr("=");
    printInt(d);
    printStr("\n");

    printInt(a);
    printStr("*");
    printInt(b);
    printStr("=");
    printInt(e);
    printStr("\n");

    printInt(a);
    printStr("/");
    printInt(b);
    printStr("=");
    printInt(f);
    printStr("\n");
    
    return 0;
}