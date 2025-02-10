#!/usr/bin/env python3
import time, os, sys, math

# Cube points
points = [
    [-1, -1, -1], [1, -1, -1], [1, 1, -1], [-1, 1, -1],
    [-1, -1,  1], [1, -1,  1], [1, 1,  1], [-1, 1,  1]
]

edges = [(0,1),(1,2),(2,3),(3,0),(4,5),(5,6),(6,7),(7,4),(0,4),(1,5),(2,6),(3,7)]

def rotateX(p, angle):
    y = p[1] * math.cos(angle) - p[2] * math.sin(angle)
    z = p[1] * math.sin(angle) + p[2] * math.cos(angle)
    return (p[0], y, z)

def rotateY(p, angle):
    x = p[0] * math.cos(angle) - p[2] * math.sin(angle)
    z = p[0] * math.sin(angle) + p[2] * math.cos(angle)
    return (x, p[1], z)

def project(p, width=40, height=20, scale=10):
    x = int(p[0] * scale) + width
    y = int(p[1] * scale) + height
    return (x, y)

def draw_cube(angleX, angleY):
    rotated = [rotateX(rotateY(p, angleY), angleX) for p in points]
    projected = [project(p) for p in rotated]

    buffer = [[" " for _ in range(80)] for _ in range(40)]
    
    for edge in edges:
        p1, p2 = projected[edge[0]], projected[edge[1]]
        x1, y1 = p1
        x2, y2 = p2

        if 0 <= x1 < 80 and 0 <= y1 < 40 and 0 <= x2 < 80 and 0 <= y2 < 40:
            buffer[y1][x1] = "#"
            buffer[y2][x2] = "#"

    os.system("clear")
    for row in buffer:
        print("".join(row))

angleX, angleY = 0, 0
while True:
    draw_cube(angleX, angleY)
    angleX += 0.1
    angleY += 0.1
    time.sleep(0.05)

