import matplotlib.pyplot as plt
import numpy as np


# Data for Software Sobel
software_labels = ['Total', 'Stall', 'Idle']
software_cycles = [487.4, 378.6, 195.4]


colors = ['#264653', '#2a9d8f', '#e9c46a', '#f4a261', '#e76f51', '#dad7cd']

fig, ax = plt.subplots()

ax.bar(software_labels, software_cycles, color = colors)


# Adding labels
ax.set_ylabel('Cycles (millions)')
ax.set_title('Breakdown of Software Implementation')

# Display the chart
plt.savefig('idle.svg')
