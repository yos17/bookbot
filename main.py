from stats import get_num_words, get_num_chars, sort_stats
import sys

# Assignment

# Write a new function called get_book_text. 
# It takes a filepath as input and returns the contents of the file as a string.
def get_book_text(filepath):
    with open(filepath, "r") as f:
        file_contents = f.read()
    return file_contents

# Write a main function the uses get_book_text with the relative path to your frankenstein.txt file to print the entire contents of the book to the console.
def main():
    if len(sys.argv) != 2:
        print("Usage: python3 main.py <path_to_book>")
        sys.exit(1)
    filepath = sys.argv[1]
    num_words = get_num_words(get_book_text(filepath))
    print("============ BOOKBOT ============")
    print(f"Analyzing book found at {filepath}...")
    print("----------- Word Count ----------")
    print(f"Found {num_words} total words")
    print("--------- Character Count -------")  
    num_chars = get_num_chars(get_book_text(filepath))
    result_arr = sort_stats(num_chars)
    for r in result_arr:
        if (r['char'] != "\n") and (r['char'] != " "):
            print(f"{r['char']}: {r['count']}")
        
        


# Call main() at the bottom of your file to execute your program.
# Test your program!
main()