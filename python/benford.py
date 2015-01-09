# python2 script to demonstrate Benford's law
from random import *
p = random() * 100 + .001 # start with a random number greater than 0
growth = random() + .001  # make sure we have at least a little growth
digit_count = [0]*10  #keep track of number of times we see each leading digit

trials = 0
for i in range(100000):
  p = p + p * growth
  if p == float("Inf"): break
  trials += 1
  sci_notation = "%e" % p
  first_digit = ord(sci_notation[0]) - ord('0')
  digit_count[first_digit] += 1

print "Total number of trials=",trials
print "leading_digit, raw_count, fraction"
for i in range(1,10):
  print i, digit_count[i], float(digit_count[i])/trials  

# Of course the probability of the first digit being "1" in an exponential system is simply the space
# it takes up on a log chart.
# If we consider the numbers 1.0 through 9.9999999999... (or 10), then
# The ones take up 1.0 through 1.9999999... (or 2).
# space_of_numbers_starting_with_1 = log(2)-log(1)
# space_of_all_numbers = log(10)-log(1)
# percent = (log(2)-log(1)) / (log(10)-log(1)) ~= .301
# You'll get the same answer using any number of digits:
# (log(20)-log(10)) / (log(100)-log(10)) ~= .301
