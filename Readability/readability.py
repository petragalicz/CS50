import cs50


def main():

    # prompting for text
    text = cs50.get_string("Text: ")

    # counting letters, words, sentences
    count_letter = int(compute_letters(text))
    count_word = int(compute_words(text))
    count_sentence = int(compute_sentences(text))

    # counting avarage
    L = (count_letter / count_word) * 100
    S = (count_sentence / count_word) * 100

    # counting the grade
    index = 0.0588 * L - 0.296 * S - 15.8

    # printing the result
    if index >= 16.0:
        print("Grade 16+")
    elif index < 1.0:
        print("Before Grade 1")
    else:
        print(f"Grade {round(index)}")


def compute_letters(text):
    # count the number of letters in a text
    count = 0
    # check each character if it is alphabetical
    for i in range(len(text)):
        if text[i].isalpha():
            count += 1

    return count


def compute_words(text):
    # count the number of words in a text
    count = 1
    # count after each space
    for i in range(len(text)):
        if text[i] == ' ':
            count += 1

    return count


def compute_sentences(text):
    # count the number of words in a text
    count = 0
    for i in range(len(text)):
        if text[i] == '.' or text[i] == '!' or text[i] == '?':
            count += 1

    return count


if __name__ == "__main__":
    main()