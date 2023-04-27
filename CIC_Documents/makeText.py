import os

# Get the current working directory
current_directory = os.getcwd()

# Create a list of folders and subfolders
folders = []
for root, dirs, files in os.walk(current_directory):
    for directory in dirs:
        folders.append(os.path.join(root, directory))

# Create a text file for each folder
for folder in folders:
    # Create the folder
    #os.makedirs(folder)

    # Create the text file
    with open(folder + ".txt", "w") as f:
        f.write("Your task is to use google to research best practice on " + folder + " and write the results below this line and save this file.")

# Print a message to the user
print("Text files created successfully.")

# Pause the program so that the user can see the message
input("Press Enter to continue...")
