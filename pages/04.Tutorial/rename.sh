#!bin/sh

read N
for i in 1 2 .. $N
    do
	cmd="cd $i.* && mv default.md docs.md && cd .."
        if [$i < 10]; then
	    cmd="cd 0$i.* && mv default.md docs.md && cd .."
	fi
	$cmd
    done
