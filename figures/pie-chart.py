import matplotlib.pyplot as plt
import numpy as np


# Data for Software Sobel
labels = ['Sobel Operator', 'Movement Detection', 'Grayscale', 'Image Acquisition']
software_cycles = [391.4, 52.8, 34.1, 9.2]

total_cycles = sum(software_cycles)

sizes = []
for i in range(len(software_cycles)):
    sizes.append(software_cycles[i]/total_cycles)

colors = ['#264653', '#2a9d8f', '#e9c46a', '#f4a261', '#e76f51']

fig, ax = plt.subplots()

ax.pie(sizes, labels = labels,
       colors=colors)


# Adding labels

ax.set_title('Breakdown of Software Implementation')

# Display the chart
plt.savefig('breakdown.svg')
