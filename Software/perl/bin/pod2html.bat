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
=pod

=head1 NAME

pod2html - convert .pod files to .html files

=head1 SYNOPSIS

    pod2html --help --htmldir=<name> --htmlroot=<URL>
             --infile=<name> --outfile=<name>
             --podpath=<name>:...:<name> --podroot=<name>
             --cachedir=<name> --flush --recurse --norecurse
             --quiet --noquiet --verbose --noverbose
             --index --noindex --backlink --nobacklink
             --header --noheader --poderrors --nopoderrors
             --css=<URL> --title=<name>

=head1 DESCRIPTION

Converts files from pod format (see L<perlpod>) to HTML format.

=head1 ARGUMENTS

pod2html takes the following arguments:

=over 4

=item help

  --help

Displays the usage message.

=item htmldir

  --htmldir=name

Sets the directory to which all cross references in the resulting HTML file
will be relative. Not passing this causes all links to be absolute since this
is the value that tells Pod::Html the root of the documentation tree.

Do not use this and --htmlroot in the same call to pod2html; they are mutually
exclusive.

=item htmlroot

  --htmlroot=URL

Sets the base URL for the HTML files.  When cross-references are made, the
HTML root is prepended to the URL.

Do not use this if relative links are desired: use --htmldir instead.

Do not pass both this and --htmldir to pod2html; they are mutually exclusive.

=item infile

  --infile=name

Specify the pod file to convert.  Input is taken from STDIN if no
infile is specified.

=item outfile

  --outfile=name

Specify the HTML file to create.  Output goes to STDOUT if no outfile
is specified.

=item podroot

  --podroot=name

Specify the base directory for finding library pods.

=item podpath

  --podpath=name:...:name

Specify which subdirectories of the podroot contain pod files whose
HTML converted forms can be linked-to in cross-references.

=item cachedir

  --cachedir=name

Specify which directory is used for storing cache. Default directory is the
current working directory.

=item flush

  --flush

Flush the cache.

=item backlink

  --backlink

Turn =head1 directives into links pointing to the top of the HTML file.

=item nobacklink

  --nobacklink

Do not turn =head1 directives into links pointing to the top of the HTML file
(default behaviour).

=item header

  --header

Create header and footer blocks containing the text of the "NAME" section.

=item noheader

  --noheader

Do not create header and footer blocks containing the text of the "NAME"
section (default behaviour).

=item poderrors

  --poderrors

Include a "POD ERRORS" section in the outfile if there were any POD errors in
the infile (default behaviour).

=item nopoderrors

  --nopoderrors

Do not include a "POD ERRORS" section in the outfile if there were any POD
errors in the infile.

=item index

  --index

Generate an index at the top of the HTML file (default behaviour).

=item noindex

  --noindex

Do not generate an index at the top of the HTML file.


=item recurse

  --recurse

Recurse into subdirectories specified in podpath (default behaviour).

=item norecurse

  --norecurse

Do not recurse into subdirectories specified in podpath.

=item css

  --css=URL

Specify the URL of cascading style sheet to link from resulting HTML file.
Default is none style sheet.

=item title

  --title=title

Specify the title of the resulting HTML file.

=item quiet

  --quiet

Don't display mostly harmless warning messages.

=item noquiet

  --noquiet

Display mostly harmless warning messages (default behaviour). But this is not
the same as "verbose" mode.

=item verbose

  --verbose

Display progress messages.

=item noverbose

  --noverbose

Do not display progress messages (default behaviour).

=back

=head1 AUTHOR

Tom Christiansen, E<lt>tchrist@perl.comE<gt>.

=head1 BUGS

See L<Pod::Html> for a list of known bugs in the translator.

=head1 SEE ALSO

L<perlpod>, L<Pod::Html>

=head1 COPYRIGHT

This program is distributed under the Artistic License.

=cut

BEGIN { pop @INC if $INC[-1] eq '.' }
use Pod::Html;

pod2html @ARGV;

__END__
:endofperl
