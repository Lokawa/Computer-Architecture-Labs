//Zhu Fanyue
//522031910547

#include "cachelab.h"
#include <stdio.h>
#include <stdlib.h>
#include <getopt.h>
#include <unistd.h>
#include <string.h>

int hits, misses, evictions;
int h,v,s,E,b,S;
char file[100];

typedef struct {
    int valid;
    int tag;
    int time;
} cacheLine, *cacheSet, **cache;

cache cacheSim=NULL;

void initCache()
{
    int i,j;
    cacheSim=(cache)malloc(S*sizeof(cacheSet));
    for(i=0;i<S;i++)
    {
        cacheSim[i]=(cacheSet)malloc(E*sizeof(cacheLine));
        for(j=0;j<E;j++)
        {
         //   cacheSim[i][j]=(cacheLine)malloc(sizeof(cacheLine));
            cacheSim[i][j].valid=0;
            cacheSim[i][j].tag=0;
            cacheSim[i][j].time=0;
        }
    }
}

void freeCache()
{
    for(int i=0;i<S;i++)
    {
        free(cacheSim[i]);
    }
    free(cacheSim);
}

void updateCache(int addr)
{
    int set=(addr>>b)&((1<<s)-1);
    int tag=addr>>(s+b);
    for (int i=0;i<E;i++)
    {
        if (cacheSim[set][i].valid==1 && cacheSim[set][i].tag==tag)
        {
            hits++;
            cacheSim[set][i].time=0;
            if (v==1)
            {
                printf(" hit");
            }
            return;
        }
    }
    //miss
    if (v==1)
    {
        printf(" miss");
    }
    for (int i=0;i<E;i++)
    {
        if (cacheSim[set][i].valid==0)
        {
            misses++;
            cacheSim[set][i].valid=1;
            cacheSim[set][i].tag=tag;
            cacheSim[set][i].time=0;
            return;
        }
    }
    //eviction
    evictions++;
    misses++;
    int max=0;
    for (int i=0;i<E;i++)
    {
        if (cacheSim[set][i].time>cacheSim[set][max].time)
        {
            max=i;
        }
    }
    cacheSim[set][max].tag=tag;
    cacheSim[set][max].time=0;
    if (v==1)
    {
        printf(" eviction");
    }
}

void phase()
{
    FILE *fp=fopen(file,"r");
    if (fp==NULL)
    {
        printf("File not found.\n");
        exit(0);
    }
    char op;
    int addr,size;
    while (fscanf(fp," %c %x,%d",&op,&addr,&size)>0)
    {
        if (v==1)
        {
            printf(" %c %x,%d",op,addr,size);
        }
        switch (op)
        {
        case 'L':
            updateCache(addr);
            break;
        case 'S':
            updateCache(addr);
            break;
        case 'M':
            updateCache(addr);
            updateCache(addr);
            break;
        default:
            break;
        }
        if (v==1) printf("\n");
        for (int i=0;i<S;i++)
        {
            for (int j=0;j<E;j++)
            {
                if (cacheSim[i][j].valid==1)
                {
                    cacheSim[i][j].time++;
                }
            }
        }
    }
    fclose(fp);
    freeCache();
}

void help()
{
    printf("Usage: ./csim [-hv] -s <num> -E <num> -b <num> -t <file>\n");
    printf("Options:\n");
    printf("  -h         Print this help message.\n");
    printf("  -v         Optional verbose flag.\n");
    printf("  -s <num>   Number of set index bits.\n");
    printf("  -E <num>   Number of lines per set.\n");
    printf("  -b <num>   Number of block offset bits.\n");
    printf("  -t <file>  Trace file.\n");
    printf("\n");
}
int main(int argc, char *argv[])
{
    h=v=0;
    int opt;
    hits=misses=evictions=0;
    while ((opt=getopt(argc,argv,"hvs:E:b:t:"))!=-1)
    {
        switch (opt)
        {
        case 'h':
            h=1;
            help();
            break;
        case 'v':
            v=1;

            break;
        case 's':
            s=atoi(optarg);
            S=1<<s;
            break;
        case 'E':
            E=atoi(optarg);
            break;
        case 'b':
            b=atoi(optarg);
            break;
        case 't':
            strcpy(file,optarg);
            break;
        default:
            printf("Invalid arguments.\n");
            printf("Use -h for help.\n");
            break;
        }
    }
    if (s==0 || E==0 || b==0 || file[0]=='\0')
    {
        printf("Invalid arguments.\n");
        exit(0);
    }
    S=1<<s;
    FILE *fp=fopen(file,"r");
    if (fp==NULL)
    {
        printf("File not found.\n");
        exit(0);
    }
    initCache();
    phase();
    printSummary(hits,misses,evictions);
    return 0;
}
