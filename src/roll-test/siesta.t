#!/usr/bin/perl -w
# siesta roll installation test.  Usage:
# siesta.t [nodetype]
#   where nodetype is one of "Compute", "Dbnode", "Frontend" or "Login"
#   if not specified, the test assumes either Compute or Frontend

use Test::More qw(no_plan);

my $appliance = $#ARGV >= 0 ? $ARGV[0] :
                -d '/export/rocks/install' ? 'Frontend' : 'Compute';
my $installedOnAppliancesPattern = '.';
my $isInstalled = -d '/opt/siesta';
my $output;

my $TESTFILE = 'tmpsiesta';

open(OUT, ">$TESTFILE.sh");
print OUT <<END;
#!/bin/bash
if test -f /etc/profile.d/modules.sh; then
  . /etc/profile.d/modules.sh
  module load siesta
fi
mkdir $TESTFILE.dir
cd $TESTFILE.dir
cp -r \$SIESTAHOME/Tests/* .
cd h2o
make SIESTA=`which siesta`
ls *.out
cat *.out
END
close(OUT);

# siesta-common.xml
if($appliance =~ /$installedOnAppliancesPattern/) {
  ok($isInstalled, 'siesta installed');
} else {
  ok(! $isInstalled, 'siesta not installed');
}
SKIP: {

  skip 'siesta not installed', 5 if ! $isInstalled;
  $output = `bash $TESTFILE.sh 2>&1`;
  like($output, qr/\.out/, 'siesta output file created');
  like($output, qr/Electric dipole.*0\.558/, 'siesta test run output');

  skip 'modules not installed', 3 if ! -f '/etc/profile.d/modules.sh';
  `/bin/ls /opt/modulefiles/applications/siesta/[0-9]* 2>&1`;
  ok($? == 0, 'siesta module installed');
  `/bin/ls /opt/modulefiles/applications/siesta/.version.[0-9]* 2>&1`;
  ok($? == 0, 'siesta version module installed');
  ok(-l '/opt/modulefiles/applications/siesta/.version',
     'siesta version module link created');

}

`rm -fr $TESTFILE*`;
