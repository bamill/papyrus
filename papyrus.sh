#!/bin/bash

read -e -p "State your project name: `echo $'\n-> '`" proj
read -e -p "your project directory being? `echo $'\n-> '`" rootdir
read -e -p "what your source directory? `echo $'\n-> '`" srcdir
read -e -p "pls gib include directory `echo $'\n-> '`" includes
read -e -p "Okay! what your header file spot is? `echo $'\n-> '`" header
read -e -p "muh CFLAGS!?!?!?!? `echo $'\n-> '`" cflags

grep -R '^\(int\|char\|void\|float\|double\|long\|unsigned\)' $srcdir | cut -d: -f2 | tr $'\t' ' ' | sed -r -e 's/(.+[^;])$/\1;/' -e 's/([a-zA-Z]+)/\1\t\t\t/' | grep -Ev 'main+' | sort | uniq >> $header

src=$(cd $srcdir && find . -name '*.c' | cut -d/ -f2- | tr $'\n' ' ' | sed -r -e "s|([^ ]*\.c)|$srcdir/&|g")

objs=$(echo $src | sed -r -e 's/([^ ]*)(\.c)/\1.o/g')

printf "NAME = $proj\n" > $rootdir/Makefile
printf "SRC = $src\n" >> $rootdir/Makefile
printf "OBJS = $objs\n" >> $rootdir/Makefile
printf "CFLAGS = $cflags\n" >> $rootdir/Makefile
printf "\n" >> $rootdir/Makefile

for file in $objs
do
    printf "$file: " >> $rootdir/Makefile
    printf "$file\n" | sed -r -e 's/([^ ]*)(\.o)/\1.c/' >> $rootdir/Makefile
    printf "\tgcc \$CFLAGS $file\n" | sed -r -e 's/([^ ]*)(\.o)/\1.c/' >> $rootdir/Makefile
    printf "\n" >> $rootdir/Makefile
done
