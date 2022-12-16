from collections import defaultdict
import re
from sys import stdin


REGEX = r"Sensor at x=(-?\d+), y=(-?\d+): closest beacon is at x=(-?\d+), y=(-?\d+)"


def read_input():
    sensors = {}
    for line in stdin:
        result = re.search(REGEX, line)
        sensor = tuple(map(int, result.group(1, 2)))
        beacon = tuple(map(int, result.group(3, 4)))
        sensors[sensor] = beacon
    return sensors


def dist(a, b):
    return abs(a[0] - b[0]) + abs(a[1] - b[1])


def interval_covered_in_row(sensor_pos, dist, row):
    y_dist = abs(sensor_pos[1] - row)
    if y_dist > dist:
        return None
    x_dist = dist - y_dist
    return (sensor_pos[0] - x_dist, sensor_pos[0] + x_dist)


def union_of_intervals(intervals):
    union = []
    for begin, end in sorted(intervals):
        if union and union[-1][1] >= begin - 1:
            union[-1][1] = max(union[-1][1], end)
        else:
            union.append([begin, end])
    return [tuple(l) for l in union]


def part2(sensors, bound):
    for row in range(bound + 1):
        intervals = []
        for sensor, beacon in sensors.items():
            d = dist(sensor, beacon)
            interval = interval_covered_in_row(sensor, d, row)
            if interval:
                intervals.append(interval)
        intervals = union_of_intervals(intervals)
        if (len(intervals) > 1):
            return (intervals[0][1] + 1) * 4000000 + row


def part1(sensors, row):
    covered = set()

    # Find the range covered by each sensor
    for sensor, beacon in sensors.items():
        distance = dist(sensor, beacon)
        curr_range = interval_covered_in_row(sensor, distance, row)
        if curr_range:
            covered.update(range(curr_range[0], curr_range[1] + 1))
    
    # Remove all beacons
    for beacon in sensors.values():
        if beacon[1] == row and beacon[0] in covered:
            covered.remove(beacon[0])
    
    return len(covered)


if __name__ == "__main__":
    sensors = read_input()
    print("Part 1:", part1(sensors, 2000000))
    print("Part 2:", part2(sensors, 4000000))
