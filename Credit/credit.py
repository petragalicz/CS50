from cs50 import get_int

# prompting for number
number = get_int("Credit card number: ")

# counting the number of digits
ndigits = 0
n = number

while n != 0:
    n = int(n / 10)
    ndigits += 1

# last to second (even) digits
digit = 0
multi = 0
multidigit = 0
sumeven = 0

for i in range(1, ndigits, 2):
    # take each digit
    digit = int((number / (10 ** i)) % 10)
    # multiply by 2
    multi = int(digit * 2)
    # sum the mulitplied digits
    while multi > 0:
        multidigit = int(multi % 10)
        sumeven = int(sumeven + multidigit)
        multi = int(multi / 10)

# odd digits
digitodd = 0
sumodd = 0
sumdigit = 0

for j in range(0, ndigits, 2):
    # take each digit
    digitodd = int((number / (10 ** j)) % 10)
    # sum the odd digits
    while digitodd > 0:
        sumdigit = int(digitodd % 10)
        sumodd = int(sumodd + sumdigit)
        digitodd = int(digitodd / 10)

# adding the two sums
sum = 0
sum = int(sumeven + sumodd)

# last digit of sum
lastsum = 0
lastsum = int(sum % 10)

# first & second digit
firstdigit = 0
seconddigit = 0

firstdigit = int((number / (10 ** (ndigits-1))) % 10)
seconddigit = int((number / (10 ** (ndigits-2))) % 10)

# printing the result

if lastsum == 0 and (ndigits == 13 or ndigits == 16) and firstdigit == 4:
    print("VISA")
elif lastsum == 0 and ndigits == 15 and firstdigit == 3 and (seconddigit == 4 or seconddigit == 7):
    print("AMEX")
elif lastsum == 0 and ndigits == 16 and firstdigit == 5 and (seconddigit == 1 or seconddigit == 2 or seconddigit == 3 or seconddigit == 4 or seconddigit == 5):
    print("MASTERCARD")
else:
    print("INVALID")