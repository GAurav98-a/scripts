#!/usr/bin/python3
from itertools import product
import csv
li_2=[]
head=[]
seq=[]
lib={}
tetra={}
seq1=""
fi=input("GIVE FILE NAME\n>")
def library():
    l=['A','T','G','C']
    li_1=product(l,repeat=4)
    li_2=[''.join(i) for i in li_1]
    for ind in range(len(li_2)):
        lib[li_2[ind]]=0 #initializing the values
    caltet(li_2)
def filein(fi):
    file=open(fi,"r")
    seq1=""
    for lines in file:
        if(lines.startswith(">")):
            seq.append(seq1)
            head.append(lines)
            seq1=""
        if(lines.startswith(">")==False):
            if(lines.endswith("\n")):#find lines ending with newline character
                seq1= seq1 + lines.replace("\n","")#adding sequence while removing newline
    seq.append(seq1)#for appending last remaining sequence.
    seq.remove(seq[0])
    file.close()
def caltet(li_2):
    for se in range(len(seq)):#going sequence by sequence
        for ind in range(len(seq[se])):#going character by character
            if(len(seq[se][ind:ind+4])==4):
                if(seq[se][ind:ind+4].find('Y') == -1):#if Y character comes
                    x=seq[se][ind:ind+4]
                    lib[x]= lib[x] + 1
        tetra[head[se]]=lib.copy()
        for ind in range(len(li_2)):
            lib[li_2[ind]]=0 #initializing the values
    print(tetra)
def filewrite():
    col_name=[]
    col_name.append("header")
    for keys in lib:
        col_name.append(keys)
    try:
        with open("tetra_count.csv","w") as csvf:
            wr=csv.DictWriter(csvf, fieldnames=col_name)
            wr.writeheader()
            for di in tetra:
                csvf.write(di.replace(" ","_").replace("\n",""))#writing headers
                wr.writerow(tetra[di])
    except IOError:
        print("IOError")
filein(fi)
library()
filewrite()