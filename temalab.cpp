#include <bits/stdc++.h>
using namespace std;

ifstream fin("input0.txt");
ofstream fout("output0.txt");

int T, task, n, descriptor, sizef, d=0;
int v[1024];

void add(int desc, int sz){
    int start=-1, finish=-1;
    for(int i=0;i<1024;i++){
        if(start==-1 && v[i]==0){
            start=i;
            continue;
        }
        if(start!=-1 && v[i]==0){
            finish=i;
            if(finish-start+1>=sz)
                break;
            continue;
        }
        if (v[i]!=0){
            if(finish-start+1>=sz)
                break;
            else{
                start=-1;
                finish=-1;
            }
            continue;
        }
    } 
    for(int i=start; i<=finish;i++)
        v[i]=desc;
    fout<<desc<<":("<<start<<", "<<finish<<")\n";
}

void get(int desc){
    int start=-1, finish=-1; 
    for(int i=0;i<1024;i++){
        if(start==-1 && v[i]==desc)
            start=i;
        else if(start!=-1 && v[i]==desc)
            finish=i;
        else if(finish!=-1 && v[i]!=desc)
            break;
    }
    fout<<"("<<start<<", "<<finish<<")\n";
}

void deletee(int desc){
    int start=0, finish=-1, valc=v[0]; 
    for(int i=0;i<1024;i++){
        if(valc!=v[i]){
            finish=i-1;
            if(valc!=desc)
                fout<<valc<<": ("<<start<<", "<<finish<<")\n";
            start=i;
            valc=v[i];
        }
        if(v[i]==desc)
            v[i]=0;
    }
    for(int i=0;i<1024;i++)
        fout<<v[i]<<" ";
    fout<<"\n";
}
void defragmentation(){
    int k=0;
    for(int i=0;i<1024;i++){
        if(v[i]!=0){
            int aux=v[k];
            v[k]=v[i];
            v[i]=aux;
            k++;
        }
    }
    for(int i=0;i<1024;i++)
        fout<<v[i]<<" ";
}

int main(){
    double time1 = (double) clock();    
    time1 = time1 / CLOCKS_PER_SEC; 
    fin>>T;
    for(int q=1;q<=T;q++){
        fin>>task;
        if(task==1){
            fin>>n;
            for(int i=1;i<=n;i++){
                fin>>descriptor>>sizef;
                add(descriptor, ceil((float)sizef/8));
            }
        }
        else if(task==2){
            fin>>descriptor;
            get(descriptor);
        }
        else if(task==3){
            fin>>descriptor;
            deletee(descriptor);
        }
        else if(task==4){
            defragmentation();
        }
    }
    double timedif = ( ((double) clock()) / CLOCKS_PER_SEC) - time1;
    printf("The elapsed time is %lf seconds\n", timedif);
    
    return 0;
}