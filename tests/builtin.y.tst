echo ===== break continue =====

breakfunc ()
while true; do
	echo break ok
	break 999
	echo break ng
done
while true; do
	echo break ok 2
	breakfunc
	echo break ng 2
done

contfunc ()
while true; do
	echo continue ok
	continue 999
	echo continue ng
done
for i in 1 2; do
	echo continue $i
	contfunc
done


echo ===== eval =====

breakfunc2 ()
while true; do
	echo break ok
	break -i
	echo break ng
done

contfunc2 ()
while true; do
	echo continue ok
	continue -i
	echo continue ng
done

eval echo -i
eval -i -- 'echo 1' 'echo 2'
eval -i 'echo 1' 'echo 2; break -i; echo 3' 'echo 4'
eval -i 'echo 1' 'echo 2; continue -i; echo 3' 'echo 4'
eval -i 'echo 1' 'while true; do echo 2; breakfunc2; echo 3; done' 'echo 4'
eval -i 'echo 1' 'while true; do echo 2; contfunc2; echo 3; done' 'echo 4'
eval -i '(exit 2)' 'echo status1=$?; (exit 3); break -i'
echo status2=$?


echo ===== . =====

set a b c
. ./dot.t 1 2 3
echo $count
echo -"$@"-


echo ===== command =====

command -V if then else elif fi do done case esac while until for { } ! in
command -V _no_such_command_ 2>/dev/null || echo not found
command -V : . break continue eval exec exit export readonly return set shift \
times trap unset
#TODO command -V newgrp
command -V bg cd command false fg getopts jobs kill pwd read true umask wait

testreg() {
	command -V $1 | grep -v "^$1: regular builtin "
}
testreg typeset
testreg disown
testreg type

command -Vb sh 2>&1 || PATH= command -vp sh >/dev/null && echo ok

command -b cat /dev/null 2>/dev/null
echo command -b cat = $?
command -B exit 127 2>/dev/null
echo command -B exit 127 = $?
(command exit 10; echo not reached)
echo command exit 10 = $?

type type | grep -v "^type: regular builtin"


echo ===== suspend =====

set -m
($INVOKE $TESTEE -imc --norc 'echo 1; suspend; echo 2'; echo end)&
wait $!
kill -l $?
fg >/dev/null
set +m


echo ===== exec =====

(exec -a sh $TESTEE -c 'echo $0')
(exec --as=sh $TESTEE -c 'echo $0')
(foo=123 bar=456 exec -c env | grep -v ^_ | sort)
(foo=123 bar=456 exec --clear env | grep -v ^_ | sort)
