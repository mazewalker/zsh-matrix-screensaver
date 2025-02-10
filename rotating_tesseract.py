import numpy as np
import matplotlib.pyplot as plt

fig = plt.figure()
ax = fig.add_subplot(111, projection="3d")

# Define 4D points
points = np.array([
    [1,1,1,1], [-1,1,1,1], [1,-1,1,1], [-1,-1,1,1],
    [1,1,-1,1], [-1,1,-1,1], [1,-1,-1,1], [-1,-1,-1,1],
    [1,1,1,-1], [-1,1,1,-1], [1,-1,1,-1], [-1,-1,1,-1],
    [1,1,-1,-1], [-1,1,-1,-1], [1,-1,-1,-1], [-1,-1,-1,-1]
])

edges = [(i, j) for i in range(16) for j in range(i+1, 16) if np.sum(np.abs(points[i] - points[j])) == 2]

# Project 4D to 3D
def project(points, angle):
    rotation = np.array([[np.cos(angle), -np.sin(angle)], [np.sin(angle), np.cos(angle)]])
    return points[:, :3] @ rotation

def rotate4D(point, angle):
    x, y, z, w = point
    new_x = x * math.cos(angle) - w * math.sin(angle)
    new_w = x * math.sin(angle) + w * math.cos(angle)
    return np.array([new_x, y, z, new_w])

def project4Dto3D(point, distance=2):
    x, y, z, w = point
    factor = distance / (distance - w) if distance != w else 1
    return np.array([x * factor, y * factor, z * factor])

def draw_tesseract(angle):
    ax.clear()
    transformed = project(points, angle)
    for edge in edges:
        ax.plot(*zip(*transformed[edge]), "r")

    plt.draw()
    plt.pause(0.1)

while True:
    for angle in np.linspace(0, 2*np.pi, 100):
        draw_tesseract(angle)

