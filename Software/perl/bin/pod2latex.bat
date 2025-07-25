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
    eval 'exec C:\Users\godwi\OneDrive\Desktop\sysfiles\Software\perl\bin\perl.exe -S $0 ${1+"$@"}'
	if $running_under_some_shell;

# pod2latex conversion program

use strict;
use Pod::LaTeX;
use Pod::Find qw/ pod_find /;
use Pod::Usage;
use Getopt::Long;
use File::Basename;
use Symbol;

my $VERSION = "1.01";

# return the entire contents of a text file
# whose name is given as argument
sub _get {
    my $fn = shift;
    my $infh = gensym;
    open $infh, $fn
        or die "Could not open file $fn: $!\n";
    local $/;
    return <$infh>;
}

# Read command line arguments

my %options = (
	       "help"   => 0,
	       "man"    => 0,
	       "sections" => [],
	       "full"   => 0,
	       "out"    => undef,
	       "verbose" => 0,
	       "modify" => 0,
	       "h1level" => 1,  # section is equivalent to H1
	       "preamble" => [],
	       "postamble" => [],
	      );
# "prefile" is just like "preamble", but the argument 
# comes from the file named by the argument
$options{"prefile"} = sub { shift; push @{$options{"preamble"}}, _get(shift) };
# the same between "postfile" and "postamble"
$options{"postfile"} = sub { shift; push @{$options{"postamble"}}, _get(shift) };

GetOptions(\%options, 
	   "help",
	   "man",
	   "verbose",
	   "full",
	   "sections=s@",
	   "out=s",
	   "modify",
	   "h1level=i",
	   "preamble=s@",
	   "postamble=s@",
	   "prefile=s", 
	   "postfile=s"
	  ) || pod2usage(2);

pod2usage(1)  if ($options{help});
pod2usage(-verbose => 2)  if ($options{man});


# Read all the files from the command line
my @files = @ARGV;

# Now find which ones are real pods and convert 
# directories to their contents.

# Extract the pods from each arg since some of them might
# be directories
# This is not as efficient as using pod_find to search through
# everything at once but it allows us to preserve the order 
# supplied by the user

my @pods;
foreach my $arg (@files) {
  my %pods = pod_find($arg);
  push(@pods, sort keys %pods);
}

# Abort if nothing to do
if ($#pods == -1) {
  warn "None of the supplied Pod files actually exist\n";
  exit;
}

# Only want to override the preamble and postamble if we have
# been given values.
my %User;
$User{UserPreamble} = join("\n", @{$options{'preamble'}})
  if ($options{preamble} && @{$options{preamble}});
$User{UserPostamble} = join("\n", @{$options{'postamble'}})
  if ($options{postamble} && @{$options{postamble}});



# If $options{'out'} is set we are processing to a single output file
my $multi_documents;
if (exists $options{'out'} && defined $options{'out'}) {
  $multi_documents = 0;
} else {
  $multi_documents = 1;
}

# If the output file is not specified it is assumed that
# a single output file is required per input file using
# a .tex extension rather than any existing extension

if ($multi_documents) {

  # Case where we just generate one input per output

  foreach my $pod (@pods) {

    if (-f $pod) {

      my $output = $pod;
      $output = basename($output, '.pm', '.pod','.pl') . '.tex';

      # Create a new parser object
      my $parser = new Pod::LaTeX(
				  AddPreamble => $options{'full'},
				  AddPostamble => $options{'full'},
				  MakeIndex => $options{'full'},
				  TableOfContents => $options{'full'},
				  ReplaceNAMEwithSection => $options{'modify'},
				  UniqueLabels => $options{'modify'},
				  Head1Level => $options{'h1level'},
				  LevelNoNum => $options{'h1level'} + 1,
                                  %User,
				 );

      # Select sections if supplied
      $parser->select(@{ $options{'sections'}})
	if @{$options{'sections'}};

      # Derive the input file from the output file
      $parser->parse_from_file($pod, $output);

      print "Written output to $output\n" if $options{'verbose'};

    } else {
      warn "File $pod not found\n";
    }

  }
} else {

  # Case where we want everything to be in a single document

  # Need to open the output file ourselves
  my $output = $options{'out'};
  $output .= '.tex' unless $output =~ /\.tex$/;

  # Use auto-vivified file handle in perl 5.6
  my $outfh = gensym;
  open ($outfh, ">$output") || die "Could not open output file: $!\n";

  # Flag to indicate whether we have converted at least one file
  # indicates how many files have been converted
  my $converted = 0;

  # Loop over the input files
  foreach my $pod (@pods) {

    if (-f $pod) {

      warn "Converting $pod\n" if $options{'verbose'};

      # Open the file (need the handle)
      # Use auto-vivified handle in perl 5.6
      my $podfh = gensym;
      open ($podfh, "<$pod") || die "Could not open pod file $pod: $!\n";

      # if this is the first file to be converted we may want to add
      # a preamble (controlled by command line option)
      my $preamble = 0;
      $preamble = 1 if ($converted == 0 && $options{'full'});

      # if this is the last file to be converted may want to add
      # a postamble (controlled by command line option)
      # relies on a previous pass to check existence of all pods we
      # are converting.
      my $postamble = ( ($converted == $#pods && $options{'full'}) ? 1 : 0 );

      # Open parser object
      # May want to start with a preamble for the first one and
      # end with an index for the last
      my $parser = new Pod::LaTeX(
				  MakeIndex => $options{'full'},
				  TableOfContents => $preamble,
				  ReplaceNAMEwithSection => $options{'modify'},
				  UniqueLabels => $options{'modify'},
				  StartWithNewPage => $options{'full'},
				  AddPreamble => $preamble,
				  AddPostamble => $postamble,
				  Head1Level => $options{'h1level'},
				  LevelNoNum => $options{'h1level'} + 1,
                                  %User
				 );

      # Store the file name for error messages
      # This is a kluge that breaks the data hiding of the object
      $parser->{_INFILE} = $pod;

      # Select sections if supplied
      $parser->select(@{ $options{'sections'}})
	if @{$options{'sections'}};

      # Parse it
      $parser->parse_from_filehandle($podfh, $outfh);

      # We have converted at least one file
      $converted++;

    } else {
      warn "File $pod not found\n";
    }

  }

  # Should unlink the file if we didn't convert anything!
  # dont check for return status of unlink
  # since there is not a lot to be done if the unlink failed
  # and the program does not rely upon it.
  unlink "$output" unless $converted;

  # If verbose
  warn "Converted $converted files\n" if $options{'verbose'};

}

exit;

__END__

=head1 NAME

pod2latex - convert pod documentation to latex format

=head1 SYNOPSIS

  pod2latex *.pm

  pod2latex -out mytex.tex *.pod

  pod2latex -full -sections 'DESCRIPTION|NAME' SomeDir

  pod2latex -prefile h.tex -postfile t.tex my.pod

=head1 DESCRIPTION

C<pod2latex> is a program to convert POD format documentation
(L<perlpod>) into latex. It can process multiple input documents at a
time and either generate a latex file per input document or a single
combined output file.

=head1 OPTIONS AND ARGUMENTS

This section describes the supported command line options. Minimum
matching is supported.

=over 4

=item B<-out>

Name of the output file to be used. If there are multiple input pods
it is assumed that the intention is to write all translated output
into a single file. C<.tex> is appended if not present.  If the
argument is not supplied, a single document will be created for each
input file.

=item B<-full>

Creates a complete C<latex> file that can be processed immediately
(unless C<=for/=begin> directives are used that rely on extra packages).
Table of contents and index generation commands are included in the
wrapper C<latex> code.

=item B<-sections>

Specify pod sections to include (or remove if negated) in the
translation.  See L<Pod::Select/"SECTION SPECIFICATIONS"> for the
format to use for I<section-spec>. This option may be given multiple
times on the command line.This is identical to the similar option in
the C<podselect()> command.

=item B<-modify>

This option causes the output C<latex> to be slightly
modified from the input pod such that when a C<=head1 NAME>
is encountered a section is created containing the actual
pod name (rather than B<NAME>) and all subsequent C<=head1>
directives are treated as subsections. This has the advantage
that the description of a module will be in its own section
which is helpful for including module descriptions in documentation.
Also forces C<latex> label and index entries to be prefixed by the
name of the module.

=item B<-h1level>

Specifies the C<latex> section that is equivalent to a C<H1> pod
directive. This is an integer between 0 and 5 with 0 equivalent to a
C<latex> chapter, 1 equivalent to a C<latex> section etc. The default
is 1 (C<H1> equivalent to a latex section).

=item B<-help>

Print a brief help message and exit.

=item B<-man>

Print the manual page and exit.

=item B<-verbose>

Print information messages as each document is processed.

=item B<-preamble>

A user-supplied preamble for the LaTeX code. Multiple values
are supported and appended in order separated by "\n".
See B<-prefile> for reading the preamble from a file.

=item B<-postamble>

A user supplied postamble for the LaTeX code. Multiple values
are supported and appended in order separated by "\n".
See B<-postfile> for reading the postamble from a file.

=item B<-prefile>

A user-supplied preamble for the LaTeX code to be read from the
named file. Multiple values are supported and appended in
order. See B<-preamble>.

=item B<-postfile>

A user-supplied postamble for the LaTeX code to be read from the
named file. Multiple values are supported and appended in
order. See B<-postamble>.

=back

=head1 BUGS

Known bugs are:

=over 4

=item *

Cross references between documents are not resolved when multiple
pod documents are converted into a single output C<latex> file.

=item *

Functions and variables are not automatically recognized
and they will therefore not be marked up in any special way
unless instructed by an explicit pod command.

=back

=head1 SEE ALSO

L<Pod::LaTeX>

=head1 AUTHOR

Tim Jenness E<lt>tjenness@cpan.orgE<gt>

This program is free software; you can redistribute it
and/or modify it under the same terms as Perl itself.

Copyright (C) 2000, 2003, 2004 Tim Jenness. All Rights Reserved.

=cut

__END__
:endofperl
@set "ErrorLevel=" & @goto _undefined_label_ 2>NUL || @"%COMSPEC%" /d/c @exit %ErrorLevel%
