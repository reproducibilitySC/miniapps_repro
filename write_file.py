import time

def add_text_to_file(filename, text_to_add):
    """Adds text to the end of a file.

    Args:
        filename: The name of the file to add text to.
        text_to_add: The text to add to the file.
    """
    try:
        with open(filename, "a") as file:
            file.write(text_to_add)
            time.sleep(10)  # Sleep for 10 second to ensure the file is written
    except Exception as e:
         print(f"An error occurred: {e}")

# Example usage:
filename = "result/output/miniamr_result16.txt"
text_to_add = "This is some text to add to the file.\n"
add_text_to_file(filename, text_to_add)
