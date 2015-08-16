#
# Runs a solr test over and over, collecting failures
# as fail.<timestamp> files
#
while true; do
  echo `date`
  # run the test here, redirecting stdout and stderr to t.out
  ant test -Dtests.nightly=true -Dtestcase=TestReloadDeadlock > t.out 2>&1 
  # ant test -Dtestcase=TestRealTimeGet -Dtests.iters=100 > t.out 2>&1 
  # ant test -Dtestcase=ChaosMonkeySafeLeaderTest -Dtests.iters=1 -Dtests.multiplier=1 > t.out 2>&1 
  #ant test -Dtestcase=ChaosMonkeyNothingIsSafeTest -Dtests.iters=1 -Dtests.multiplier=1 > t.out 2>&1 
  #grep "ERROR" t.out

  #handle ctrl-c
  if [ $? == 130 ]; then
    exit 130
  fi

  # grep for some interesting things we would want to see in the output
  grep "AssertionError" t.out
  grep "Corrupt" t.out
  grep "^BUILD" t.out

  # this currently works fine to tell if the test succeeded.
  # we don't test the return code of the testsuite itself because
  # that can often fail for other reasons (some threads not closed yet, etc)
  grep " OK " t.out

  if [ $? != "0" ]; then
    EXT=`date '+%y%m%d_%H%M%S'`
    cp build/solr-core/test/tests-report.txt fail.$EXT
    echo "##################### DETECTED FAIL! file is fail.$EXT"
    # exit 1
  fi

  # were there any asserts tripped or corrupt indexes?
  grep "AssertionError\|Corrupt" t.out
  if [ $? == "0" ]; then
    EXT=`date '+%y%m%d_%H%M%S'`
    cp build/solr-core/test/tests-report.txt fail.$EXT.assert
    echo "##################### DETECTED FAIL! file is fail.$EXT.assert"
    # exit 1
  fi

  mv t.out t.out.bak

#  grep EOF t.out
#  if [ $? == "0" ]; then
#    exit 1
#  fi
 
done
