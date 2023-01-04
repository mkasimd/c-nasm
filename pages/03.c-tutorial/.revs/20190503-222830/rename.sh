#!bin/sh

read N
$O = '0'
for i in 1 2 .. $N
    do
        if [$i < 10]; then
	    mv $O$i*/default.md $O$i*/docs.md
	fi
	mv $i*/default.md $i*/docs.md
    done
