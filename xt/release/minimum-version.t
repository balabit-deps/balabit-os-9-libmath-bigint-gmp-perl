# -*- mode: perl; -*-

use strict;
use warnings;

use Test::More;

eval 'use Test::MinimumVersion';
plan skip_all => 'Test::MinimumVersion required for testing minimum version'
  if $@;

all_minimum_version_from_metayml_ok();
