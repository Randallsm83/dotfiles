# CPAN configuration for Perl
# This is a minimal config - CPAN will expand it on first run
# https://metacpan.org/pod/CPAN

$CPAN::Config = {
  'build_dir' => "$ENV{XDG_CACHE_HOME}/cpan/build",
  'cpan_home' => "$ENV{XDG_DATA_HOME}/cpan",
  'histfile' => "$ENV{XDG_STATE_HOME}/cpan/history",
  'keep_source_where' => "$ENV{XDG_CACHE_HOME}/cpan/sources",
  'prefs_dir' => "$ENV{XDG_CONFIG_HOME}/cpan/prefs",
  
  # Installation preferences
  'makepl_arg' => "INSTALL_BASE=$ENV{XDG_DATA_HOME}/perl5",
  'mbuild_install_arg' => "--install_base $ENV{XDG_DATA_HOME}/perl5",
  
  # Build behavior
  'auto_commit' => 1,
  'build_requires_install_policy' => 'yes',
  'colorize_output' => 1,
  'colorize_print' => 'bold',
  'colorize_warn' => 'yellow',
  
  # Don't ask questions
  'prerequisites_policy' => 'follow',
  'use_sqlite' => 1,
};

1;
