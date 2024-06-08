/* 
 * trans.c - Matrix transpose B = A^T
 *
 * Each transpose function must have a prototype of the form:
 * void trans(int M, int N, int A[N][M], int B[M][N]);
 *
 * A transpose function is evaluated by counting the number of misses
 * on a 1KB direct mapped cache with a block size of 32 bytes.
 */ 
#include <stdio.h>
#include "cachelab.h"

int is_transpose(int M, int N, int A[N][M], int B[M][N]);

/* 
 * transpose_submit - This is the solution transpose function that you
 *     will be graded on for Part B of the assignment. Do not change
 *     the description string "Transpose submission", as the driver
 *     searches for that string to identify the transpose function to
 *     be graded. 
 */
void transpose_61(int M, int N, int A[N][M], int B[M][N])
{
    //1793 FOR 61*67
    //12 VARIABLES
    int v1,v2,v3,v4,v5,v6,v7,v8;
    for (int i=0;i<N;i+=8)
    {
        for (int j=0;j<M;j+=8)
        {
            if (i+8<N && j+8<M)
            {
                for (int k=j;k<j+8;k++)
                {
                    v1=A[i][k];
                    v2=A[i+1][k];
                    v3=A[i+2][k];
                    v4=A[i+3][k];
                    v5=A[i+4][k];
                    v6=A[i+5][k];
                    v7=A[i+6][k];
                    v8=A[i+7][k];
                    B[k][i]=v1;
                    B[k][i+1]=v2;
                    B[k][i+2]=v3;
                    B[k][i+3]=v4;
                    B[k][i+4]=v5;
                    B[k][i+5]=v6;
                    B[k][i+6]=v7;
                    B[k][i+7]=v8;
                }
            }
            else
            {
                for (int k=0;k<8 && i+k<N;k++)
                {
                    for (int l=0;l<8 && j+l<M;l++)
                    {
                        B[j+l][i+k]=A[i+k][j+l];
                    }
                }
            }
        }
    }
}

void transpose_64(int M, int N, int A[N][M], int B[M][N])
{
    //1636 FOR 64*64
    //11 VARIABLES
    int v1,v2,v3,v4,v5,v6,v7,v8;
    int i,j,k;
    for (i=0;i<N;i+=8)
    {
        for (j=0;j<M;j+=8)
        {
            for (k=0;k<8;k+=2)
            {
                v1=A[i+k][j];
                v2=A[i+k][j+1];
                v3=A[i+k][j+2];
                v4=A[i+k][j+3];
                v5=A[i+k+1][j];
                v6=A[i+k+1][j+1];
                v7=A[i+k+1][j+2];
                v8=A[i+k+1][j+3];
                B[j][i+k]=v1;
                B[j+1][i+k]=v2;
                B[j+2][i+k]=v3;
                B[j+3][i+k]=v4;
                B[j][i+k+1]=v5;
                B[j+1][i+k+1]=v6;
                B[j+2][i+k+1]=v7;
                B[j+3][i+k+1]=v8;
            }
            for (int k=0;k<8;k+=2)
            {
                v1=A[i+k][j+4];
                v2=A[i+k][j+5];
                v3=A[i+k][j+6];
                v4=A[i+k][j+7];
                v5=A[i+k+1][j+4];
                v6=A[i+k+1][j+5];
                v7=A[i+k+1][j+6];
                v8=A[i+k+1][j+7];
                B[j+4][i+k]=v1;
                B[j+5][i+k]=v2;
                B[j+6][i+k]=v3;
                B[j+7][i+k]=v4;
                B[j+4][i+k+1]=v5;
                B[j+5][i+k+1]=v6;
                B[j+6][i+k+1]=v7;
                B[j+7][i+k+1]=v8;
            }
        }
    }
}

void transpose_32(int M, int N, int A[N][M], int B[M][N])
{
    //288 FOR 32*32
    //11 VARIABLES
    int v1,v2,v3,v4,v5,v6,v7,v8;
    for (int i=0;i<N;i+=8)
    {
        for (int j=0;j<M;j+=8)
        {
            for (int k=j;k<j+8;k++)
            {
                v1=A[i][k];
                v2=A[i+1][k];
                v3=A[i+2][k];
                v4=A[i+3][k];
                v5=A[i+4][k];
                v6=A[i+5][k];
                v7=A[i+6][k];
                v8=A[i+7][k];
                B[k][i]=v1;
                B[k][i+1]=v2;
                B[k][i+2]=v3;
                B[k][i+3]=v4;
                B[k][i+4]=v5;
                B[k][i+5]=v6;
                B[k][i+6]=v7;
                B[k][i+7]=v8;
            }
            
        }
    }
}

char transpose_submit_desc[] = "Transpose submission";
void transpose_submit(int M, int N, int A[N][M], int B[M][N])
{
    if (M==61 && N==67)
    {
        transpose_61(M,N,A,B);
    }
    else if (M==64 && N==64)
    {
        transpose_64(M,N,A,B);
    }
    else if (M==32 && N==32)
    {
        transpose_32(M,N,A,B);
    }    
}

char transpose1_desc[] = "Simple column-wise transpose";
void transpose1(int M, int N, int A[N][M], int B[M][N])
{
    for (int j=0;j<M;j++)
    {
        for (int i=0;i<N;i++)
        {
            B[j][i]=A[i][j];
        }
    }
}

char transpose2_desc[] = "block transpose2*2";
void transpose2(int M, int N, int A[N][M], int B[M][N])
{
    int blocksize_col=M/2;
    int blocksize_row=N/2;
    for (int i=0;i<N;i+=blocksize_row)
    {
        for (int j=0;j<M;j+=blocksize_col)
        {
            for (int k=0;k<blocksize_row && i+k<N;k++)
            {
                for (int l=0;l<blocksize_col && j+l<M;l++)
                {
                    B[j+l][i+k]=A[i+k][j+l];
                }
            }
        }
    }
}

char transpose3_desc[] = "block transpose3*3";
void transpose3(int M, int N, int A[N][M], int B[M][N])
{
    int blocksize_col=M/3;
    int blocksize_row=N/3;
    for (int i=0;i<N;i+=blocksize_row)
    {
        for (int j=0;j<M;j+=blocksize_col)
        {
            for (int k=0;k<blocksize_row && i+k<N;k++)
            {
                for (int l=0;l<blocksize_col && j+l<M;l++)
                {
                    B[j+l][i+k]=A[i+k][j+l];
                }
            }
        }
    }
}

char transpose4_desc[] = "block transpose4*4";
void transpose4(int M, int N, int A[N][M], int B[M][N])
{
    int blocksize_col=M/4;
    int blocksize_row=N/4;
    for (int i=0;i<N;i+=blocksize_row)
    {
        for (int j=0;j<M;j+=blocksize_col)
        {
            for (int k=0;k<blocksize_row && i+k<N;k++)
            {
                for (int l=0;l<blocksize_col && j+l<M;l++)
                {
                    B[j+l][i+k]=A[i+k][j+l];
                }
            }
        }
    }
}

char transpose5_desc[] = "block transpose5*5";
void transpose5(int M, int N, int A[N][M], int B[M][N])
{
    int blocksize_col=M/5;
    int blocksize_row=N/5;
    for (int i=0;i<N;i+=blocksize_row)
    {
        for (int j=0;j<M;j+=blocksize_col)
        {
            for (int k=0;k<blocksize_row && i+k<N;k++)
            {
                for (int l=0;l<blocksize_col && j+l<M;l++)
                {
                    B[j+l][i+k]=A[i+k][j+l];
                }
            }
        }
    }
}
/* 
 * You can define additional transpose functions below. We've defined
 * a simple one below to help you get started. 
 */ 

/* 
 * trans - A simple baseline transpose function, not optimized for the cache.
 */
char trans_desc[] = "Simple row-wise scan transpose";
void trans(int M, int N, int A[N][M], int B[M][N])
{
    int i, j, tmp;

    for (i = 0; i < N; i++) {
        for (j = 0; j < M; j++) {
            tmp = A[i][j];
            B[j][i] = tmp;
        }
    }    

}

/*
 * registerFunctions - This function registers your transpose
 *     functions with the driver.  At runtime, the driver will
 *     evaluate each of the registered functions and summarize their
 *     performance. This is a handy way to experiment with different
 *     transpose strategies.
 */
void registerFunctions()
{
    /* Register your solution function */
    registerTransFunction(transpose_submit, transpose_submit_desc); 

    /* Register any additional transpose functions */
   // registerTransFunction(trans, trans_desc); 

    //registerTransFunction(transpose1, transpose1_desc);

    //registerTransFunction(transpose2, transpose2_desc);
   // registerTransFunction(transpose3, transpose3_desc);
   // registerTransFunction(transpose4, transpose4_desc);
   // registerTransFunction(transpose5, transpose5_desc);
}

/* 
 * is_transpose - This helper function checks if B is the transpose of
 *     A. You can check the correctness of your transpose by calling
 *     it before returning from the transpose function.
 */
int is_transpose(int M, int N, int A[N][M], int B[M][N])
{
    int i, j;

    for (i = 0; i < N; i++) {
        for (j = 0; j < M; ++j) {
            if (A[i][j] != B[j][i]) {
                return 0;
            }
        }
    }
    return 1;
}

