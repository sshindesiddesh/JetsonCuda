#include<stdio.>
#include<math.h>
#include<string.h>
#include<iostream>
#include<cuda.h>


__global__ void sq(int *d,int n)
{
	__shared__ s[n];
	int t= threadIdx.x;
	if(t==0 || t==2)
		s[t]= d[2*t] * d[2*t+1];
	if(t==1)
		s[t]= 2*(d[2*t]*d[2*t+1]);
	__syncthreads();
	d[2*t]=s[t];
}
int main()
{
	int n=6;
	int ori[6],d[6],ans1;
	int no,x,y;
	
	cout<<"Enter the number";
	cin>>no;
	
	x=(no/10)*10;
	y=no%10;
	
	ori[0]=ori[2]=ori[4]=x;
	ori[1]=ori[3]=ori[6]=y;
	
	int *d_d;
	
	cudaMalloc(&d_d,n*sizeof(int));
	cudaMemcpy(d_d,ori,n*sizeof(int)),cudaMemcpyHostToDevice);
	sq<<<1,n/2>>>(d_d,n/2);
	cudaMemcpy(d,d_d,n*sizeof(int)),cudaMemcpyDeviceToHost);
	cudaFree(d_d);
	
	ans1=d[0]+d[2]+d[4];
	cout<<"Ans is"<<ans1;
	return 0;
}

