import sys
import csv


def main():

    # correct number of command line arguments
    if len(sys.argv) != 3:
        print("Usage: python dna.py data.csv sequence.txt")

    # creating list for people
    persons = []

    # Reading names and str into the memory from csv file

    with open(sys.argv[1]) as data_file:
        reader = csv.DictReader(data_file)
        for row in reader:
            persons.append(row)

    # creating list for dna
    dna = []

    # Reading dna sequence into the memory from txt file

    with open(sys.argv[2]) as seq_file:
        dna = seq_file.read()

    # creating a dictionary for putting the dna sequences in
    str_counts = {}
    for key in persons[0]:
        if key != 'name':
            str_counts[key] = 0

    # counting the subsequent dnas
    for str_name in str_counts:
        count = 0
        dna_name = str_name
        while str_name in dna:
            count += 1
            str_name += dna_name
        # putting the result in a dictionary
        str_counts[dna_name] = count

    # converting values to string
    for str_name, value in str_counts.items():
        str_counts[str_name] = str(value)

    # checking if it matches any person
    for i in persons:
        if set(str_counts.items()).issubset(set(i.items())):
            print(i['name'])
            break
    else:
        print("No match")


if __name__ == "__main__":
    main()