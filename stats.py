def get_num_words(text):
    return len(text.split())

def get_num_chars(text):
    result = {}
    text_lower = text.lower()
    for char in text_lower:
        if char not in result:
            result[char] = 0
        result[char] += 1 
    return result 

# Add a new function to your stats.py file that takes the dictionary of characters 
# and their counts and returns a sorted list of dictionaries.
# Each dictionary should have two key-value pairs: one for the character and one for the count.
# Sort from greatest to least by the count.
# The .sort() method will be helpful here (see the hint).
def sort_on(dict):
    return dict['count']
    
def sort_stats(chars_dict):
    chars_dict_arr = []
    for k,v in chars_dict.items():
        chars_dict_arr.append({'char':k, 'count':v})
    chars_dict_arr.sort(reverse=True, key=sort_on)
    return chars_dict_arr
        