/*
Test File 5
Archit Agarwal and Aryaman Jain
*/

//Complex Code Testing File 2
//Sliding Window Technique and Longest Increasing Subsequence


// O(n*k) solution for finding maximum sum of 
// a subarray of size k 
  
// Returns maximum sum in a subarray of size k. 
int maxSum(int arr[], int n, int k) 
{ 
    // Initialize result 
    int max_sum = INT_MIN; 
  
    // Consider all blocks starting with i. 
    int i;
    for (i = 0; i < n - k + 1; i++) { 
        int current_sum = 0; 
        int j;
        for (j = 0; j < k; j++) 
            current_sum = current_sum + arr[i + j]; 
  
        // Update result if required. 
        max_sum = max(current_sum, max_sum); 
    } 
  
    return max_sum; 
} 

/* A Naive C/C++ recursive implementation  
   of LIS problem */
  
/* To make use of recursive calls, this  
   function must return two things: 
   1) Length of LIS ending with element arr[n-1].  
      We use max_ending_here for this purpose 
   2) Overall maximum as the LIS may end with  
      an element before arr[n-1] max_ref is  
      used this purpose. 
   The value of LIS of full array of size n  
   is stored in *max_ref which is our final result  
*/
int _lis( int arr[], int n, int *max_ref) 
{ 
    /* Base case */
    if (n == 1) 
        return 1; 
  
    // 'max_ending_here' is length of LIS  
    // ending with arr[n-1] 
    int res, max_ending_here = 1;  
  
    /* Recursively get all LIS ending with arr[0],  
       arr[1] ... arr[n-2]. If arr[i-1] is smaller  
       than arr[n-1], and max ending with arr[n-1]  
       needs to be updated, then update it */
    int i;
    for (i = 1; i < n; i++) 
    { 
        res = _lis(arr, i, max_ref); 
        if (arr[i-1] < arr[n-1] && res + 1 > max_ending_here) 
            max_ending_here = res + 1; 
    } 
  
    // Compare max_ending_here with the overall  
    // max. And update the overall max if needed 
    if (*max_ref < max_ending_here) 
       *max_ref = max_ending_here; 
  
    // Return length of LIS ending with arr[n-1] 
    return max_ending_here; 
} 
  
// The wrapper function for _lis() 
int lis(int arr[], int n) 
{ 
    // The max variable holds the result 
    int max = 1; 
  
    // The function _lis() stores its result in max 
    _lis( arr, n, &max ); 
  
    // returns max 
    return max; 
} 
  
// Driver code 
int main() 
{ 
	//implementing sliding window technique
    int arr1[] = { 1, 4, 2, 10, 2, 3, 1, 0, 20 }; 
    int k = 4; 
    int sld = maxSum(arr1, 9, k); 

    //implementing largest increasing subsequence
    int arr2[] = { 10, 22, 9, 33, 21, 50, 41, 60 }; 
    int len = lis( arr2, 8); 
    return 0; 
} 
  