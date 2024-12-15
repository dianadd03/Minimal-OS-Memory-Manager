#include <bits/stdc++.h>
using namespace std;

ifstream fin("input1.txt");
ofstream fout("output1.txt");

int T, task, n, descriptor, sizef, d=0;
int mat[1024][1024];

void add(int desc, int sz){
    int L;
    int start, finish;
    for(int i=0;i<1024;i++){
        start=-1, finish=-1;
        for(int j=0;j<1024;j++){
            if(start==-1 && mat[i][j]==0){
                start=j;
                continue;
            }
            if(start!=-1 && mat[i][j]==0){
                finish=j;
                if(finish-start+1>=sz)
                    break;
                continue;
            }
            if (mat[i][j]!=0){
                if(finish-start+1>=sz)
                    break;
                else{
                    start=-1;
                    finish=-1;
                }
                continue;
            }
        }
        if(finish-start+1>=sz){
            L=i;
            break;
        }
    }

    for(int i=start; i<=finish;i++)
        mat[L][i]=desc;
    fout<<desc<<":("<<"("<<L<<", "<<start<<"), "<<"("<<L<<", "<<finish<<"))\n";
}

 void get(int desc){
    int start, finish;
    for(int i=0;i<2024;i++){
        start=-1, finish=-1;
        for(int j=0;j<1024;j++){
            if(start==-1 && mat[i][j]==desc){
                start=j;
                continue;
            }
            if(start!=-1 && mat[i][j]==desc){
                finish=j;
                continue;
            }
            if(finish!=-1 && mat[i][j]!=desc){
                break;
            }
        }
        if(start!=-1 && finish!=-1){
            fout<<"("<<"("<<i<<", "<<start<<"), "<<"("<<i<<", "<<finish<<"))\n";
            break;
        }
    }
}

void deletee(int desc){
    int start, finish, valc;
    for(int i=0;i<1024;i++){
        start=0, finish=-1;
        valc=mat[i][0];
        for(int j=0;j<1024;j++){
           if(valc!=mat[i][j]){
            finish=j-1;
            if(valc!=desc)
                fout<<valc<<":("<<"("<<i<<", "<<start<<"), "<<"("<<i<<", "<<finish<<"))\n";
            start=j;
            valc=mat[i][j];
           }
           if(mat[i][j]==desc)
            mat[i][j]=0;
        }
    }
}


void defragmentation(){
    ///defrag pe linii
    int start, finish, valc;
    for(int j=0;j<1024;j++){
        int k=0;
        for(int i=0;i<1024;i++){
            if(mat[j][i]!=0){
                int aux=mat[j][k];
                mat[j][k]=mat[j][i];
                mat[j][i]=aux;
                k++;
            }
        }
    }
    ///defrag-mutare
    for(int i=0;i<1023;i++){
        int k=0;
        for(int j=0;j<1024;j++){
            if(mat[i][j]==0){
                if(k==0){
                    valc=mat[i+1][0];
                    for(int h=0;h<1024;h++){
                        if(mat[i+1][h]!=valc)
                            break;
                        ++k;
                    }
                    k--;
                }
                if(k>=0 && j+k<1024){
                    mat[i][j]=valc;
                    mat[i+1][k]=0;
                    --k;
                }
            }
        }
    }
    ///defrag pe linii
    /*for(int j=0;j<1024;j++){
        int k=0;
        for(int i=0;i<1024;i++){
            if(mat[j][i]!=0){
                int aux=mat[j][k];
                mat[j][k]=mat[j][i];
                mat[j][i]=aux;
                k++;
            }
        }
    }*/
    for(int i=0;i<1024;i++){
        start=0, finish=-1;
        valc=mat[i][0];
        for(int j=0;j<1024;j++){
           if(valc!=mat[i][j]){
            finish=j-1;
            fout<<valc<<":("<<"("<<i<<", "<<start<<"), "<<"("<<i<<", "<<finish<<"))\n";
            start=j;
            valc=mat[i][j];
           }
        }
    }
}

int main(){
    /*double time1 = (double) clock();
    time1 = time1 / CLOCKS_PER_SEC; */
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
    for(int i=0;i<1024;i++){
        for(int j=0;j<1024;j++)
            fout<<mat[i][j]<<" ";
        fout<<"\n";
    }
    /*double timedif = ( ((double) clock()) / CLOCKS_PER_SEC) - time1;
    printf("The elapsed time is %lf seconds\n", timedif);*/
    return 0;
}
