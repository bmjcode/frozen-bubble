#!/usr/bin/env perl
# Build script for frozen-bubble under Strawberry Perl using PAR::Packer.
# Usage: Run `perl win32/exebuild.pl` from the top-level source directory.

use strict;
use File::Basename;
use File::Copy;

# Copy DLLs needed to run the game from Strawberry Perl's MinGW installation.
# These are the names under 5.14.4.1; you may need to adjust for your version.
my @path = split(/;/, $ENV{"PATH"});
my @dll_names = (
  ## These are all the DLLs in Strawberry Perl's c\bin\.
  ## The ones needed to run the game were determined by trial and error.
  #"libcharset-1__.dll",
  #"libeay32__.dll",
  #"libexpat-1__.dll",
  #"libexslt-0__.dll",
  #"libfreetype-6__.dll",
  #"libgcc_s_sjlj-1.dll",
  #"libgd-2__.dll",
  #"libgfortran-3.dll",
  #"libgif-6__.dll",
  #"libglut-0__.dll",
  #"libgomp-1.dll",
  "libiconv-2__.dll",
  #"libjpeg-8__.dll",
  #"liblzma-5__.dll",
  #"libmysql__.dll",
  "libpng15-15__.dll",
  #"libpq__.dll",
  #"libquadmath-0.dll",
  #"libssh2-1__.dll",
  #"libssp-0.dll",
  #"libstdc++-6.dll",
  #"libt1-5__.dll",
  #"libtiff-5__.dll",
  #"libtiffxx-5__.dll",
  #"libxml2-2__.dll",
  #"libXpm__.dll",
  #"libxslt-1__.dll",
  #"pthreadGC2-w64.dll",
  #"ssleay32__.dll",
  "zlib1__.dll",
);
foreach my $dll_name (@dll_names) {
  if (! -e $dll_name) {
    foreach my $dir (@path) {
      my $dll_path = "$dir/$dll_name";
      if (-e $dll_path) {
        print "Grabbing $dll_name from $dll_path\n";
        copy($dll_path, $dll_name);
        last;
      }
    }
  }
}

# Build frozen-bubble.exe and frozen-bubble-editor.exe
foreach my $script (qw(frozen-bubble frozen-bubble-editor)) {
  my $cmdline = "pp -g -I lib -o $script.exe bin\\$script";
  print "$cmdline\n";
  system $cmdline;
}
