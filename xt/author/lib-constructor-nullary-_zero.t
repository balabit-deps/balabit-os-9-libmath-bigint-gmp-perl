# -*- mode: perl; -*-

use strict;
use warnings;

use Test::More tests => 5;

###############################################################################
# Read and load configuration file and backend library.

use Config::Tiny ();

my $config_file = 'xt/author/lib.ini';
my $config = Config::Tiny -> read('xt/author/lib.ini')
  or die Config::Tiny -> errstr();

# Read the library to test.

our $LIB = $config->{_}->{lib};

die "No library defined in file '$config_file'"
  unless defined $LIB;
die "Invalid library name '$LIB' in file '$config_file'"
  unless $LIB =~ /^[A-Za-z]\w*(::\w+)*\z/;

# Read the reference type(s) the library uses.

our $REF = $config->{_}->{ref};

die "No reference type defined in file '$config_file'"
  unless defined $REF;
die "Invalid reference type '$REF' in file '$config_file'"
  unless $REF =~ /^[A-Za-z]\w*(::\w+)*\z/;

# Load the library.

eval "require $LIB";
die $@ if $@;

###############################################################################

can_ok($LIB, '_zero');

my $out0 = '0';

# List context.

{
    my @got;

    my $test = qq|\@got = $LIB->_zero(); |;

    diag("\n$test\n\n") if $ENV{AUTHOR_DEBUGGING};

    eval $test;
    is($@, "", "'$test' gives emtpy \$\@");

    subtest "_zero() in list context: $test", sub {
        plan tests => 4,

        cmp_ok(scalar @got, '==', 1,
               "'$test' gives one output arg");

        is(ref($got[0]), $REF,
           "'$test' output arg is a $REF");

        is($LIB->_check($got[0]), 0,
           "'$test' output is valid");

        is($LIB->_str($got[0]), $out0,
           "'$test' output arg has the right value");
    };
}

# Scalar context.

{
    my $got;

    my $test = qq|\$got = $LIB->_zero(); |;

    diag("\n$test\n\n") if $ENV{AUTHOR_DEBUGGING};

    eval $test;
    is($@, "", "'$test' gives emtpy \$\@");

    subtest "_zero() in scalar context: $test", sub {
        plan tests => 3,

        is(ref($got), $REF,
           "'$test' output arg is a $REF");

        is($LIB->_check($got), 0,
           "'$test' output is valid");

        is($LIB->_str($got), $out0,
           "'$test' output arg has the right value");
    };
}
