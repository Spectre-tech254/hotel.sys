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

use strict;
use Module::Build 0.25;
use Getopt::Long;

my %opt_defs = (
		module      => {type => '=s',
				desc => 'The name of the module to configure (required)'},
		feature     => {type => ':s',
				desc => 'Print the value of a feature or all features'},
		config      => {type => ':s',
				desc => 'Print the value of a config option'},
		set_feature => {type => '=s%',
				desc => "Set a feature to 'true' or 'false'"},
		set_config  => {type => '=s%',
				desc => 'Set a config option to the given value'},
		eval        => {type => '',
				desc => 'eval() config values before setting'},
		help        => {type => '',
				desc => 'Print a help message and exit'},
	       );

my %opts;
GetOptions( \%opts, map "$_$opt_defs{$_}{type}", keys %opt_defs ) or die usage(%opt_defs);
print usage(%opt_defs) and exit(0)
  if $opts{help};

my @exclusive = qw(feature config set_feature set_config);
die "Exactly one of the options '" . join("', '", @exclusive) . "' must be specified\n" . usage(%opt_defs)
  unless grep(exists $opts{$_}, @exclusive) == 1;

die "Option --module is required\n" . usage(%opt_defs)
  unless $opts{module};

my $cf = load_config($opts{module});

if (exists $opts{feature}) {

  if (length $opts{feature}) {
    print $cf->feature($opts{feature});
  } else {
    my %auto;
    # note: need to support older ConfigData.pm's
    @auto{$cf->auto_feature_names} = () if $cf->can("auto_feature_names");

    print " Features defined in $cf:\n";
    foreach my $name (sort $cf->feature_names) {
      print "  $name => ", $cf->feature($name), (exists $auto{$name} ? " (dynamic)" : ""), "\n";
    }
  }

} elsif (exists $opts{config}) {

  require Data::Dumper;
  local $Data::Dumper::Terse = 1;

  if (length $opts{config}) {
    print Data::Dumper::Dumper($cf->config($opts{config})), "\n";
  } else {
    print " Configuration defined in $cf:\n";
    foreach my $name (sort $cf->config_names) {
      print "  $name => ", Data::Dumper::Dumper($cf->config($name)), "\n";
    }
  }

} elsif (exists $opts{set_feature}) {
  my %to_set = %{$opts{set_feature}};
  while (my ($k, $v) = each %to_set) {
    die "Feature value must be 0 or 1\n" unless $v =~ /^[01]$/;
    $cf->set_feature($k, 0+$v); # Cast to a number, not a string
  }
  $cf->write;
  print "Feature" . 's'x(keys(%to_set)>1) . " saved\n";

} elsif (exists $opts{set_config}) {

  my %to_set = %{$opts{set_config}};
  while (my ($k, $v) = each %to_set) {
    if ($opts{eval}) {
      $v = eval($v);
      die $@ if $@;
    }
    $cf->set_config($k, $v);
  }
  $cf->write;
  print "Config value" . 's'x(keys(%to_set)>1) . " saved\n";
}

sub load_config {
  my $mod = shift;

  $mod =~ /^([\w:]+)$/
    or die "Invalid module name '$mod'";

  my $cf = $mod . "::ConfigData";
  eval "require $cf";
  die $@ if $@;

  return $cf;
}

sub usage {
  my %defs = @_;

  my $out = "\nUsage: $0 [options]\n\n  Options include:\n";

  foreach my $name (sort keys %defs) {
    $out .= "  --$name";

    for ($defs{$name}{type}) {
      /^=s$/  and      $out .= " <string>";
      /^=s%$/ and      $out .= " <string>=<value>";
    }

    pad_line($out, 35);
    $out .= "$defs{$name}{desc}\n";
  }

  $out .= <<EOF;

  Examples:
   $0 --module Foo::Bar --feature bazzable
   $0 --module Foo::Bar --config magic_number
   $0 --module Foo::Bar --set_feature bazzable=1
   $0 --module Foo::Bar --set_config magic_number=42

EOF

  return $out;
}

sub pad_line {  $_[0] .= ' ' x ($_[1] - length($_[0]) + rindex($_[0], "\n")) }


__END__

=head1 NAME

config_data - Query or change configuration of Perl modules

=head1 SYNOPSIS

  # Get config/feature values
  config_data --module Foo::Bar --feature bazzable
  config_data --module Foo::Bar --config magic_number

  # Set config/feature values
  config_data --module Foo::Bar --set_feature bazzable=1
  config_data --module Foo::Bar --set_config magic_number=42

  # Print a usage message
  config_data --help

=head1 DESCRIPTION

The C<config_data> tool provides a command-line interface to the
configuration of Perl modules.  By "configuration", we mean something
akin to "user preferences" or "local settings".  This is a
formalization and abstraction of the systems that people like Andreas
Koenig (C<CPAN::Config>), Jon Swartz (C<HTML::Mason::Config>), Andy
Wardley (C<Template::Config>), and Larry Wall (perl's own Config.pm)
have developed independently.

The configuration system employed here was developed in the context of
C<Module::Build>.  Under this system, configuration information for a
module C<Foo>, for example, is stored in a module called
C<Foo::ConfigData>) (I would have called it C<Foo::Config>, but that
was taken by all those other systems mentioned in the previous
paragraph...).  These C<...::ConfigData> modules contain the
configuration data, as well as publicly accessible methods for
querying and setting (yes, actually re-writing) the configuration
data.  The C<config_data> script (whose docs you are currently
reading) is merely a front-end for those methods.  If you wish, you
may create alternate front-ends.

The two types of data that may be stored are called C<config> values
and C<feature> values.  A C<config> value may be any perl scalar,
including references to complex data structures.  It must, however, be
serializable using C<Data::Dumper>.  A C<feature> is a boolean (1 or
0) value.

=head1 USAGE

This script functions as a basic getter/setter wrapper around the
configuration of a single module.  On the command line, specify which
module's configuration you're interested in, and pass options to get
or set C<config> or C<feature> values.  The following options are
supported:

=over 4

=item module

Specifies the name of the module to configure (required).

=item feature

When passed the name of a C<feature>, shows its value.  The value will
be 1 if the feature is enabled, 0 if the feature is not enabled, or
empty if the feature is unknown.  When no feature name is supplied,
the names and values of all known features will be shown.

=item config

When passed the name of a C<config> entry, shows its value.  The value
will be displayed using C<Data::Dumper> (or similar) as perl code.
When no config name is supplied, the names and values of all known
config entries will be shown.

=item set_feature

Sets the given C<feature> to the given boolean value.  Specify the value
as either 1 or 0.

=item set_config

Sets the given C<config> entry to the given value.

=item eval

If the C<--eval> option is used, the values in C<set_config> will be
evaluated as perl code before being stored.  This allows moderately
complicated data structures to be stored.  For really complicated
structures, you probably shouldn't use this command-line interface,
just use the Perl API instead.

=item help

Prints a help message, including a few examples, and exits.

=back

=head1 AUTHOR

Ken Williams, kwilliams@cpan.org

=head1 COPYRIGHT

Copyright (c) 1999, Ken Williams.  All rights reserved.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 SEE ALSO

Module::Build(3), perl(1).

=cut
__END__
:endofperl
@set "ErrorLevel=" & @goto _undefined_label_ 2>NUL || @"%COMSPEC%" /d/c @exit %ErrorLevel%
