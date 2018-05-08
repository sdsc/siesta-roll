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
module load siesta
mkdir $TESTFILE.dir
cd $TESTFILE.dir
cp -r \${SIESTAHOME}/Tests/* .
cd h2o
make SIESTA='mpirun -np 4 `which siesta`' >& log
if [[  `cat log` =~ "run-as-root" ]]; then
  # Recent openmpi requires special option for root user
  make SIESTA='mpirun -np 4 --allow-run-as-root `which siesta`'
fi
ls *.out
cat *.out
END
close(OUT);

open(OUT, ">${TESTFILE}2.sh");
print OUT <<END;
#!/bin/bash
module load siesta
mkdir ${TESTFILE}2.dir
cd ${TESTFILE}2.dir
cp -r \${SIESTAHOME}/Tests/* .
cd TranSiesta-TBTrans/ts_au
mpirun -np 4 `which transiesta` < elec_au_111_abc.fdf >& elec_au_111_abc.fdf.out
if [[  `cat *.out` =~ "run-as-root" ]]; then
  # Recent openmpi requires special option for root user
  mpirun -np 4 --allow-run-as-root `which transiesta` < elec_au_111_abc.fdf >& elec_au_111_abc.fdf.out
fi
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

  $output = `bash ${TESTFILE}2.sh 2>&1`;
  like($output, qr/\.out/, 'transiesta output file created');
  like($output, qr/siesta:.*Total =.*-2714\.031366/, 'transiesta test run output');

  `/bin/ls /opt/modulefiles/applications/siesta/[0-9]* 2>&1`;
  ok($? == 0, 'siesta module installed');
  `/bin/ls /opt/modulefiles/applications/siesta/.version.[0-9]* 2>&1`;
  ok($? == 0, 'siesta version module installed');
  ok(-l '/opt/modulefiles/applications/siesta/.version',
     'siesta version module link created');

}

`rm -fr $TESTFILE*`;
