""""
I know this isn't necessary but fuck it

"""

from math import comb

num_LED = 16

# total number of possibilities
total = 2**num_LED

# function to work out percentage chance of having 'x' number of LED's on
calc_percent = lambda x: comb(num_LED, x)/total * 100

# print all possibilities
for i in range(num_LED + 1):
    print(f"{i} moles: {calc_percent(i):.2f}")