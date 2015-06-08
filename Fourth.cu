#include "stdio.h"

#define ROW 3
#define COL 2
__global__ void add(int *a,int *b,int *c)
{
	int x = blockIdx.x;
	int y = blockIdx.x;
	int i = COL*y + x;
	c[i] = a[i] + b[i];
}

int main()
{
	int a[ROW][COL],b[ROW][COL],c[ROW][COL];
	int *dev_a,*dev_b,*dev_c;
	cudaMalloc((void**)&dev_a,ROW*COL*sizeof(int));
	cudaMalloc((void**)&dev_b,ROW*COL*sizeof(int));
	cudaMalloc((void**)&dev_c,ROW*COL*sizeof(int));
	
	for(int y=0;y<ROW;y++)
	{
		for(int x=0;x<COL;x++)
		{
			a[y][x] = x;
			b[y][x] = y;
		}
	}
	
	cudaMemcpy(dev_a,a,ROW*COL*sizeof(int),cudaMemcpyHostToDevice);
	cudaMemcpy(dev_b,b,ROW*COL*sizeof(int),cudaMemcpyHostToDevice);
	
	dim3 grid(COL,ROW);
	add<<<grid,1>>>(dev_a,dev_b,dev_c);
	cudaMemcpy(c,dev_c,ROW*COL*sizeof(int),cudaMemcpyDeviceToHost);

	for(int y=0;y<ROW;y++)
	{
		for(int x=0;x<COL;x++)
		{
			printf("[%d][%d]=%d ",y,x,c[y][x]);
		}
		printf("\n");
	}
	return 0;
}
