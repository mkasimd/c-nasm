#!bin/sh

read N
$O = '0'
for i in 1 2 .. $N
    do
        if [$i < 10]; then
	    cd 0$i.*
	    mv default.md docs.md
	    cd ..
	fi
	cd $i.*
	mv default.md docs.md
	cd ..
    done
