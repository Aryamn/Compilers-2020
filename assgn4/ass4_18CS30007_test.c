
int main()
{
    int arr[6] = {1,2,3,4,5,6};
    int n=6;
    int target=1;
    int l=0,r=5;
    int ans;
    while(l<=r)
    {
        int mid = l+(r-l)/2;
        if(arr[mid]<target)
        {
            l = mid+1;
        }

        else if(arr[mid]==target)
        {
            printf("found\n");
            break;
        }

        else
        {
            r=mid-1;
        }
        
    }

    int a[100];
    a[0]=0;
    a[1]=1;
    int i=0;
    for(i=2;i<10;i++)
        a[i] = a[i-1]+a[i-2];

    float a,bt,sum=0.0;
    a = 1.0;
    bt = 2.0; 

    sum += a+bt;
    return 0;
}

