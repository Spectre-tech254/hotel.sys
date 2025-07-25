@rem = '--*-Perl-*--
@set "ErrorLevel="
@if "%OS%" == "Windows_NT" @goto WinNT
@perl -x -S "%0" %1 %2 %3 %4 %5 %6 %7 %8 %9
@set ErrorLevel=%ErrorLevel%
@goto endofperl
:WinNT
@perl -x -S %0 %*
@set ErrorLevel=%ErrorLevel%
@if NOT "%COMSPEC%" == "%SystemRoot%\system32\cmd.exe" @goto endofperl
@if %ErrorLevel% == 9009 @echo You do not have Perl in your PATH.
@goto endofperl
@rem ';
#!C:\Users\godwi\OneDrive\Desktop\sysfiles\Software\perl\bin\perl.exe 
#line 30

use warnings;
use strict;
use 5.008;

use Pod::Usage;

=head1 NAME

htmltree - Parse the given HTML file(s) and dump the parse tree

=head1 SYNOPSIS

htmltree -D3 -w file1 file2 file3

 Options:
    -D[number]  sets HTML::TreeBuilder::Debug to that figure.
    -w  turns on $tree->warn(1) for the new tree
    -h  Help message

=cut

my $warn;
my $help;

BEGIN { # We have to set debug level before we use HTML::TreeBuilder.
  $HTML::TreeBuilder::DEBUG = 0; # default debug level
  $warn = 0;
  while(@ARGV) {   # lameo switch parsing
    if($ARGV[0] =~ m<^-D(\d+)$>s) {
      $HTML::TreeBuilder::DEBUG = $1;
      print "Debug level $HTML::TreeBuilder::DEBUG\n";
      shift @ARGV;
    } elsif ($ARGV[0] =~ m<^-w$>s) {
      $warn = 1;
      shift @ARGV;
    } elsif ($ARGV[0] =~ m<^-h$>s) {
      $help = 1;
      shift @ARGV;
    } else {
      last;
    }
  }
}

pod2usage({-exitval => 0, -verbose => 1}) if($help);

use HTML::TreeBuilder;

foreach my $file (grep( -f $_, @ARGV)) {
  print
    "=" x 78, "\n",
    "Parsing $file...\n";

  my $h = HTML::TreeBuilder->new;
  $h->ignore_unknown(0);
  $h->warn($warn);
  $h->parse_file($file);

  print "- "x 39, "\n";
  $h->dump();
  $h = $h->delete(); # nuke it!
  print "\n\n";
}

exit;
__END__
:endofperl
@set "ErrorLevel=" & @goto _undefined_label_ 2>NUL || @"%COMSPEC%" /d/c @exit %ErrorLevel%
