#!/bin/bash
if [[ -z $1 || -z $2 || -z $3 ]]; then
echo PROPER USE:
echo "autovina2 <macromolecule file name>[ex:protein.pdb or protein.pdbqt] <grid box dimensions>[ex:60,60,60] <options>" 
echo "OPTIONS:"
echo "-b:   for blind Docking"
echo "-s:   for specific Docking"
echo "-a:   use autodock4 {optional}"
echo "Written by Gaurav"

else
if [[ "$3" == "-b" ]]
then
prepare_receptor4.py -r $1 -o "$1.pdbqt"
echo number of ligands:
read i;
for (( j=0;j<i;j++ ))
do
echo GIVE THE LIGAND FILE NAME
read a[j];
done
if [[ "$4" == "-a" ]] #starting autodock4 condition here.
then
for (( p=0;p<i;p++ ))
do
prepare_ligand4.py -l ${a[p]} -o "${a[p]}.pdbqt"
prepare_gpf4.py -l "${a[p]}.pdbqt" -r "$1.pdbqt" -p npts="$2" -o "grid_${a[p]}.gpf"
autogrid4 -p "grid_${a[p]}.gpf" -l "grid_${a[p]}.glg"
prepare_dpf4.py -l "${a[p]}.pdbqt" -r "$1.pdbqt" -o "${a[p]}.dpf"
autodock4 -p "${a[p]}.dpf" -l "${a[p]}.dlg"
cat "${a[p]}.dlg" | tail
paste <(grep -i "docked: model" "${a[p]}.dlg") <(grep -i "binding    =" "${a[p]}.dlg" | head -10 | sed -e 's/DOCKED:.*= //g' | sed -e 's/ \[.*\]//g')
done
else
for (( p=0;p<i;p++ ))
do
prepare_ligand4.py -l ${a[p]} -o "${a[p]}.pdbqt"
prepare_gpf.py -l "${a[p]}.pdbqt" -r "$1.pdbqt" -p npts="$2" -o "grid_${a[p]}.gpf"
vina --receptor "$1.pdbqt" --ligand "${a[p]}.pdbqt" --size_x $(grep npts "grid_${a[p]}.gpf"|cut -f 2 -d ' ') --size_y $(grep npts "grid_${a[p]}.gpf"|cut -f 3 -d ' ') --size_z $(grep npts "grid_${a[p]}.gpf"|cut -f 4 -d ' ') --center_y $(grep gridcenter "grid_${a[p]}.gpf"|cut -f 3 -d ' ') --center_z $(grep gridcenter "grid_${a[p]}.gpf"|cut -f 4 -d ' ') --center_x $(grep gridcenter "grid_${a[p]}.gpf"|cut -f 2 -d ' ') --log "dock_${a[p]}.dlg"
done
fi
fi
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
if [[ "$3" == "-s" ]] #for specific docking
then
prepare_receptor4.py -r $1 -o "$1.pdbqt"
echo "GIVE TWO RESIDUE NUMBERS {SEQUENCE NUMBER} OPPOSITE TO EACH OTHER [cavity in between] WITH THE ATOM SPECIFICATION TO LOCATE THE CAVITY CENTER"
echo "EX: 134 and CA"
echo "GIVE FIRST RESIDUE SEQ. NO.:"
read s1
echo "GIVE FIRST RESIDUE ATOM:"
read a1
echo "GIVE SECOND RESIDUE SEQ. NO.:"
read s2
echo "GIVE SECOND RESIDUE ATOM:"
read a2


echo number of ligands:
read i;
for (( j=0;j<i;j++ ))
do
echo GIVE THE LIGAND FILE NAME
read a[j];
done
nl=$i;
for (( p=0 ; p<nl ; p++ ))
do
prepare_ligand4.py -l ${a[p]} -o "${a[p]}.pdbqt"
prepare_gpf.py -l "${a[p]}.pdbqt" -r "$1.pdbqt" -p npts="$2" -o "grid_${a[p]}.gpf"


nlf=$(awk '$6 == '"$s1"'' "$1.pdbqt" | grep CA | sed 's/ \{1,\}/,/g' | grep -o ',' | wc -l )
echo $nlf
if [[ "$nlf" == "13" ]] #condition if feed number of pdb file is different
then
awk '$6 == '"$s1"'' "$1.pdbqt" | grep $a1 | sed 's/ \{1,\}/,/g' | sed -n 1p
i=$(awk '$6 == '"$s1"'' "$1.pdbqt" | grep $a1 | sed -n 1p | sed 's/ \{1,\}/,/g'| cut -f 7 -d ',')
j=$(awk '$6 == '"$s1"'' "$1.pdbqt" | grep $a1 | sed -n 1p | sed 's/ \{1,\}/,/g'| cut -f 8 -d ',')
k=$(awk '$6 == '"$s1"'' "$1.pdbqt" | grep $a1 | sed -n 1p | sed 's/ \{1,\}/,/g'| cut -f 9 -d ',')

awk '$6 == '"$s2"'' "$1.pdbqt" | grep $a2 | sed 's/ \{1,\}/,/g'
i2=$(awk '$6 == '"$s2"'' "$1.pdbqt" | grep $a2 | sed -n 1p | sed 's/ \{1,\}/,/g'| cut -f 7 -d ',')
j2=$(awk '$6 == '"$s2"'' "$1.pdbqt" | grep $a2 | sed -n 1p | sed 's/ \{1,\}/,/g'| cut -f 8 -d ',')
k2=$(awk '$6 == '"$s2"'' "$1.pdbqt" | grep $a2 | sed -n 1p | sed 's/ \{1,\}/,/g'| cut -f 9 -d ',')
fi

if [[ "$nlf" == "12" ]] #condition if feed number of pdb file is different
then
awk '$5 == '"$s1"'' "$1.pdbqt" | grep $a1 | sed 's/ \{1,\}/,/g' | sed -n 1p
i=$(awk '$5 == '"$s1"'' "$1.pdbqt" | grep $a1 | sed -n 1p | sed 's/ \{1,\}/,/g'| cut -f 6 -d ',')
j=$(awk '$5 == '"$s1"'' "$1.pdbqt" | grep $a1 | sed -n 1p | sed 's/ \{1,\}/,/g'| cut -f 7 -d ',')
k=$(awk '$5 == '"$s1"'' "$1.pdbqt" | grep $a1 | sed -n 1p | sed 's/ \{1,\}/,/g'| cut -f 8 -d ',')

awk '$5 == '"$s2"'' "$1.pdbqt" | grep $a2 | sed 's/ \{1,\}/,/g'
i2=$(awk '$5 == '"$s2"'' "$1.pdbqt" | grep $a2 | sed -n 1p | sed 's/ \{1,\}/,/g'| cut -f 6 -d ',')
j2=$(awk '$5 == '"$s2"'' "$1.pdbqt" | grep $a2 | sed -n 1p | sed 's/ \{1,\}/,/g'| cut -f 7 -d ',')
k2=$(awk '$5 == '"$s2"'' "$1.pdbqt" | grep $a2 | sed -n 1p | sed 's/ \{1,\}/,/g'| cut -f 8 -d ',')
fi

x=$(grep gridcenter "grid_${a[p]}.gpf"|cut -f 2 -d ' ')
y=$(grep gridcenter "grid_${a[p]}.gpf"|cut -f 3 -d ' ')
z=$(grep gridcenter "grid_${a[p]}.gpf"|cut -f 4 -d ' ')
i3=`echo "$i + $i2" | bc -l`
i3=`echo "$i3 / 2"| bc -l`
i4=`echo "$j + $j2" | bc -l`
i4=`echo "$i4 / 2"| bc -l`
i5=`echo "$k + $k2" | bc -l`
i5=`echo "$i5 / 2"| bc -l`
i3=`echo "$i3 + $x" | bc -l`
i4=`echo "$i4 + $y" | bc -l`
i5=`echo "$i5 + $z" | bc -l`
echo $i3
echo $i4
echo $i5
if [[ "$4" == "-a" ]]
then
prepare_gpf4.py -l "${a[p]}.pdbqt" -r "$1.pdbqt" -p npts="$2" -p gridcenter="$i3,$i4,$i5" -o "grid_${a[p]}.gpf"
autogrid4 -p "grid_${a[p]}.gpf" -l "grid_${a[p]}.glg"
prepare_dpf4.py -l "${a[p]}.pdbqt" -r "$1.pdbqt" -o "${a[p]}.dpf"
autodock4 -p "${a[p]}.dpf" -l "${a[p]}.dlg"
cat "${a[p]}.dlg" | tail
paste <(grep -i "docked: model" "${a[p]}.dlg") <(grep -i "binding    =" "${a[p]}.dlg" | head -10 | sed -e 's/DOCKED:.*= //g' | sed -e 's/ \[.*\]//g')
else
vina --receptor "$1.pdbqt" --ligand "${a[p]}.pdbqt" --size_x $(grep npts "grid_${a[p]}.gpf"|cut -f 2 -d ' ') --size_y $(grep npts "grid_${a[p]}.gpf"|cut -f 3 -d ' ') --size_z $(grep npts "grid_${a[p]}.gpf"|cut -f 4 -d ' ') --center_y $i4 --center_z $i5 --center_x $i3 --log "dock_${a[p]}.dlg"
fi
done
fi
fi