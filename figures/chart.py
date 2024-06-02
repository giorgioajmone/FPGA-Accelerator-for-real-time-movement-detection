import matplotlib.pyplot as plt
import numpy as np

#set style
#plt.style.use('seaborn-v0_8-whitegrid')

# Data for Hardware Sobel
hardware_labels = ['Movement Detection']
hardware_cycles = [17.4]

# Data for Software Sobel
software_labels = ['Sobel Operator', 'Movement Detection', 'Grayscale', 'Image']
software_cycles = [391.4, 52.8, 34.1, 9.2]

# Labels for the bars
labels = ['Accelerated', 'Baseline']

# Create positions for each bar
ind = np.arange(len(labels))

colors = ['#264653', '#2a9d8f', '#e9c46a', '#f4a261', '#e76f51']

fig, ax = plt.subplots()

# Plotting the data
p1 = ax.bar(ind[0], hardware_cycles[0], color=colors[1])

# Stacked bar for software cycles
bottom = 0
for i in range(len(software_cycles)):
    ax.bar(ind[1], software_cycles[i], bottom=bottom, label=software_labels[i], color=colors[i])
    bottom += software_cycles[i]

# Adding labels
ax.set_xlabel('Implementation')
ax.set_ylabel('Cycles (millions)')
ax.set_title('Comparison between Baseline and Accelerated')
ax.set_xticks(ind)
ax.set_xticklabels(labels)
ax.legend()

# Display the chart
plt.savefig('cycles.png')
