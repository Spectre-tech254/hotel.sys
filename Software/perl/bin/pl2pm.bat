@rem = '--*-Perl-*--
@echo off
if "%OS%" == "Windows_NT" goto WinNT
IF EXIST "%~dp0perl.exe" (
"%~dp0perl.exe" -x -S "%0" %1 %2 %3 %4 %5 %6 %7 %8 %9
) ELSE IF EXIST "%~dp0..\..\bin\perl.exe" (
"%~dp0..\..\bin\perl.exe" -x -S "%0" %1 %2 %3 %4 %5 %6 %7 %8 %9
) ELSE (
perl -x -S "%0" %1 %2 %3 %4 %5 %6 %7 %8 %9
)

goto endofperl
:WinNT
IF EXIST "%~dp0perl.exe" (
"%~dp0perl.exe" -x -S %0 %*
) ELSE IF EXIST "%~dp0..\..\bin\perl.exe" (
"%~dp0..\..\bin\perl.exe" -x -S %0 %*
) ELSE (
perl -x -S %0 %*
)

if NOT "%COMSPEC%" == "%SystemRoot%\system32\cmd.exe" goto endofperl
if %errorlevel% == 9009 echo You do not have Perl in your PATH.
if errorlevel 1 goto script_failed_so_exit_with_non_zero_val 2>nul
goto endofperl
@rem ';
#!perl
#line 29
    eval 'exec C:\Users\godwi\OneDrive\Desktop\sysfiles\Software\perl\bin\perl.exe -S $0 ${1+"$@"}'
	if $running_under_some_shell;

=head1 NAME

pl2pm - Rough tool to translate Perl4 .pl files to Perl5 .pm modules.

=head1 SYNOPSIS

B<pl2pm> F<files>

=head1 DESCRIPTION

B<pl2pm> is a tool to aid in the conversion of Perl4-style .pl
library files to Perl5-style library modules.  Usually, your old .pl
file will still work fine and you should only use this tool if you
plan to update your library to use some of the newer Perl 5 features,
such as AutoLoading.

=head1 LIMITATIONS

It's just a first step, but it's usually a good first step.

=head1 AUTHOR

Larry Wall <larry@wall.org>

=cut

use strict;
use warnings;

my %keyword = ();

while (<DATA>) {
    chomp;
    $keyword{$_} = 1;
}

local $/;

while (<>) {
    my $newname = $ARGV;
    $newname =~ s/\.pl$/.pm/ || next;
    $newname =~ s#(.*/)?(\w+)#$1\u$2#;
    if (-f $newname) {
	warn "Won't overwrite existing $newname\n";
	next;
    }
    my $oldpack = $2;
    my $newpack = "\u$2";
    my @export = ();

    s/\bstd(in|out|err)\b/\U$&/g;
    s/(sub\s+)(\w+)(\s*\{[ \t]*\n)\s*package\s+$oldpack\s*;[ \t]*\n+/${1}main'$2$3/ig;
    if (/sub\s+\w+'/) {
	@export = m/sub\s+\w+'(\w+)/g;
	s/(sub\s+)main'(\w+)/$1$2/g;
    }
    else {
	@export = m/sub\s+([A-Za-z]\w*)/g;
    }
    my @export_ok = grep($keyword{$_}, @export);
    @export = grep(!$keyword{$_}, @export);

    my %export = ();
    @export{@export} = (1) x @export;

    s/(^\s*);#/$1#/g;
    s/(#.*)require ['"]$oldpack\.pl['"]/$1use $newpack/;
    s/(package\s*)($oldpack)\s*;[ \t]*\n+//ig;
    s/([\$\@%&*])'(\w+)/&xlate($1,"",$2,$newpack,$oldpack,\%export)/eg;
    s/([\$\@%&*]?)(\w+)'(\w+)/&xlate($1,$2,$3,$newpack,$oldpack,\%export)/eg;
    if (!/\$\[\s*\)?\s*=\s*[^0\s]/) {
	s/^\s*(local\s*\()?\s*\$\[\s*\)?\s*=\s*0\s*;[ \t]*\n//g;
	s/\$\[\s*\+\s*//g;
	s/\s*\+\s*\$\[//g;
	s/\$\[/0/g;
    }
    s/open\s+(\w+)/open($1)/g;
 
    my $export_ok = '';
    my $carp      ='';


    if (s/\bdie\b/croak/g) {
	$carp = "use Carp;\n";
	s/croak "([^"]*)\\n"/croak "$1"/g;
    }

    if (@export_ok) {
	$export_ok = "\@EXPORT_OK = qw(@export_ok);\n";
    }

    if ( open(PM, ">", $newname) ) {
        print PM <<"END";
package $newpack;
use 5.006;
require Exporter;
$carp
\@ISA = qw(Exporter);
\@EXPORT = qw(@export);
$export_ok
$_
END
    }
    else {
      warn "Can't create $newname: $!\n";
    }
}

sub xlate {
    my ($prefix, $pack, $ident,$newpack,$oldpack,$export) = @_;

    my $xlated ;
    if ($prefix eq '' && $ident =~ /^(t|s|m|d|ing|ll|ed|ve|re)$/) {
	$xlated = "${pack}'$ident";
    }
    elsif ($pack eq '' || $pack eq 'main') {
	if ($export->{$ident}) {
	    $xlated = "$prefix$ident";
	}
	else {
	    $xlated = "$prefix${pack}::$ident";
	}
    }
    elsif ($pack eq $oldpack) {
	$xlated = "$prefix${newpack}::$ident";
    }
    else {
	$xlated = "$prefix${pack}::$ident";
    }

    return $xlated;
}
__END__
AUTOLOAD
BEGIN
CHECK
CORE
DESTROY
END
INIT
UNITCHECK
abs
accept
alarm
and
atan2
bind
binmode
bless
caller
chdir
chmod
chomp
chop
chown
chr
chroot
close
closedir
cmp
connect
continue
cos
crypt
dbmclose
dbmopen
defined
delete
die
do
dump
each
else
elsif
endgrent
endhostent
endnetent
endprotoent
endpwent
endservent
eof
eq
eval
exec
exists
exit
exp
fcntl
fileno
flock
for
foreach
fork
format
formline
ge
getc
getgrent
getgrgid
getgrnam
gethostbyaddr
gethostbyname
gethostent
getlogin
getnetbyaddr
getnetbyname
getnetent
getpeername
getpgrp
getppid
getpriority
getprotobyname
getprotobynumber
getprotoent
getpwent
getpwnam
getpwuid
getservbyname
getservbyport
getservent
getsockname
getsockopt
glob
gmtime
goto
grep
gt
hex
if
index
int
ioctl
join
keys
kill
last
lc
lcfirst
le
length
link
listen
local
localtime
lock
log
lstat
lt
m
map
mkdir
msgctl
msgget
msgrcv
msgsnd
my
ne
next
no
not
oct
open
opendir
or
ord
our
pack
package
pipe
pop
pos
print
printf
prototype
push
q
qq
qr
quotemeta
qw
qx
rand
read
readdir
readline
readlink
readpipe
recv
redo
ref
rename
require
reset
return
reverse
rewinddir
rindex
rmdir
s
scalar
seek
seekdir
select
semctl
semget
semop
send
setgrent
sethostent
setnetent
setpgrp
setpriority
setprotoent
setpwent
setservent
setsockopt
shift
shmctl
shmget
shmread
shmwrite
shutdown
sin
sleep
socket
socketpair
sort
splice
split
sprintf
sqrt
srand
stat
study
sub
substr
symlink
syscall
sysopen
sysread
sysseek
system
syswrite
tell
telldir
tie
tied
time
times
tr
truncate
uc
ucfirst
umask
undef
unless
unlink
unpack
unshift
untie
until
use
utime
values
vec
wait
waitpid
wantarray
warn
while
write
x
xor
y

__END__
:endofperl
