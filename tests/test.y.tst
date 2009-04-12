tmp="${TESTTMP}/test.y"

mkdir "$tmp" || exit
cd "$tmp" || exit
umask u=rwx,go=
command -V test | grep -v "^test: regular builtin "
command -V [ | grep -v "^\[: regular builtin "

tt () {
	printf "%s: " "$*"
	test "$@"
	printf "%d " $?
	[ "$@" ]
	printf "%d\n" $?
}

echo =====

tt
tt ""
tt 1
tt --
tt -n
tt -z
tt -t
tt ! ""
tt ! 1
tt ! 000

echo =====

mkfifo fifo
ln -s fifo fifolink
ln -s gid reglink
touch gid uid readable1 readable2 readable3 writable1 writable2 writable3
ln gid gidhard
mkdir sticky
chmod g+xs gid
chmod u+xs uid
chmod =,u=r readable1
chmod =,g=r readable2
chmod =,o=r readable3
chmod =,u=w writable1
chmod =,g=w writable2
chmod =,o=w writable3
chmod +t sticky
exec 3<>/dev/tty 4>&-
echo "exit 0" >> executable1
cp executable1 executable2
cp executable1 executable3
chmod u+x executable1
chmod g+x executable2
chmod o+x executable3
touch -t 200001010000 older
touch -t 200101010000 newer

# check of the -b, -c and -S operators are skipped
tt -d .
tt -d fifolink
tt -e .
tt -e fifolink
tt -e no_such_file
tt -f gid
tt -f reglink
tt -f fifolink
tt -f .
tt -f no_such_file
tt -g gid
tt -g uid
tt -h fifolink
tt -h reglink
tt -h gid
tt -h no_such_file
#tt -k sticky
tt -k gid
tt -L fifolink
tt -L reglink
tt -L gid
tt -L no_such_file
tt -n ""
tt -n 0
tt -n 1
tt -n abcde
tt -p fifo
tt -p .
tt -r readable1
tt -r readable2
tt -r readable3
tt -r writable1
tt -r writable2
tt -r writable3
tt -s gid
tt -s executable1
tt -t 3
tt -t 4
tt -u gid
tt -u uid
tt -w readable1
tt -w readable2
tt -w readable3
tt -w writable1
tt -w writable2
tt -w writable3
tt -x .
tt -x executable1
tt -x executable2
tt -x executable3
tt -x reglink
tt -z ""
tt -z 0
tt -z 1
tt -z abcde

echo =====

tt "" = ""
tt 1 = 1
tt abcde = abcde
tt 0 = 1
tt abcde = 12345
tt ! = !
tt = = =
tt "(" = ")"
tt "" != ""
tt 1 != 1
tt abcde != abcde
tt 0 != 1
tt abcde != 12345
tt ! != !
tt != != !=
tt "(" != ")"
tt ! -n ""
tt ! -n 0
tt ! -n 1
tt ! -n abcde
tt ! -z ""
tt ! -z 0
tt ! -z 1
tt ! -z abcde
tt "(" "" ")"
tt "(" 0 ")"
tt "(" abcde ")"

echo =====

tt -3 -eq -3
tt 90 -eq 90
tt 0 -eq 0
tt -3 -eq 90
tt -3 -eq 0
tt 90 -eq 0
tt -3 -ne -3
tt 90 -ne 90
tt 0 -ne 0
tt -3 -ne 90
tt -3 -ne 0
tt 90 -ne 0
tt -3 -lt -3
tt -3 -lt 0
tt 0 -lt 90
tt 0 -lt -3
tt 90 -lt -3
tt 0 -lt 0
tt -3 -le -3
tt -3 -le 0
tt 0 -le 90
tt 0 -le -3
tt 90 -le -3
tt 0 -le 0
tt -3 -gt -3
tt -3 -gt 0
tt 0 -gt 90
tt 0 -gt -3
tt 90 -gt -3
tt 0 -gt 0
tt -3 -ge -3
tt -3 -ge 0
tt 0 -ge 90
tt 0 -ge -3
tt 90 -ge -3
tt 0 -ge 0
tt older -ot newer
tt newer -ot newer
tt newer -ot older
tt older -nt newer
tt older -nt older
tt newer -nt older
tt older -ef newer
tt older -ef older
tt newer -ef older
tt gid -ef gidhard
tt gid -ef reglink

echo =====

tt "" -a ""
tt "" -a 1
tt 1 -a ""
tt 1 -a 1
tt "" -o ""
tt "" -o 1
tt 1 -o ""
tt 1 -o 1
tt "(" 12345 = 12345 ")"
tt "(" 12345 = abcde ")"
tt "(" "(" 12345 = 12345 ")" ")"
tt "(" "(" 12345 = abcde ")" ")"
tt 1 -a "(" 1 = 0 -o "(" 2 = 2 ")" ")" -a "(" = ")"
tt "" -a 0 -o 0  # -a has higher precedence than -o
tt 0 -o 0 -a ""  # -a has higher precedence than -o
tt ! "" -a ""    # 4-argument test: ! ( "" -a "" )
tt "(" ! "" -a "" ")"  # many-argument test: ! has higher precedence than -a
tt ! "(" "" -a "" ")"
tt "(" ! "" ")" -a ""
tt -n = -o -o -n = -n  # ( -n = -o ) -o ( -n = -n ) => true
tt -n = -a -n = -n     # ( -n = ) -a ( -n = -n )    => true

test 1 2 3  2>/dev/null  # invalid expression
echo "1 2 3: $?"
