import matplotlib.pyplot as plt
import numpy as np

# Read data from a file
def read_data(file_path):
    data_points = []
    with open(file_path, 'r') as file:
        for line in file:
            x, y = map(int, line.split())
            data_points.append((x, 103 - y))  # Adjust y-coordinates
    return data_points

# File path to the data file
data_file = 'robot-positions.txt'

# Parse the data into a list of points
data_points = read_data(data_file)

# Determine the grid size based on the maximum x and y coordinates
max_x = 101
max_y = 103

# Create a grid and fill cells corresponding to data points
grid = np.zeros((max_y + 1, max_x + 1))
for x, y in data_points:
    grid[y, x] = 1  # Mark the cell as filled

# Create the plot
plt.figure(figsize=(10, 10))
plt.imshow(grid, cmap='Greys', origin='lower')

# Add labels and title
plt.xlabel('X Coordinates')
plt.ylabel('Y Coordinates')
plt.title('Grid Plot of Data Points')

# Display the plot
plt.show()