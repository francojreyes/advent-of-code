from math import ceil
import re
from sys import stdin

DELIM = r":|\."
NUM = r"\d+"

minutes = 24

def read_input():
    '''
    Dictionary mapping IDs to a dictionary of form
    {'ore': int, 'clay': int, 'obsidian': (int, int), 'geode': (int, int)}
    '''
    blueprints = {}
    for line in stdin:
        blueprint = re.split(DELIM, line)
        blueprints[int(re.findall(NUM, blueprint[0])[0])] = {
            "ore": {"ore": int(re.findall(NUM, blueprint[1])[0])},
            "clay": {"ore": int(re.findall(NUM, blueprint[2])[0])},
            "obsidian": {
                "ore": int(re.findall(NUM, blueprint[3])[0]),
                "clay": int(re.findall(NUM, blueprint[3])[1])
            },
            "geode": {
                "ore": int(re.findall(NUM, blueprint[4])[0]),
                "obsidian": int(re.findall(NUM, blueprint[4])[1])
            }
        }
    return blueprints


def can_build(robot, blueprint, inventory):
    return all(inventory[mineral] >= amount for mineral, amount in blueprint[robot].items())


def visualise(trace, blueprint):
    '''
    Visualice trace
    '''
    print(trace)

    robots = {"ore": 1, "clay": 0, "obsidian": 0, "geode": 0}
    inventory = {"ore": 0, "clay": 0, "obsidian": 0, "geode": 0}

    for i, robot in enumerate(trace):
        print(f"== MINUTE {i + 1} ==")
        # Determine what can be built
        if robot:
            if not can_build(robot, blueprint, inventory):
                print("????")
                exit(1)
            print("Spending ", end="")
            for mineral, amount in blueprint[robot].items():
                print(f"{amount} {mineral} ", end="")
                inventory[mineral] -= amount
            print(f"to start building a new {robot} robot.")

        # Increment inventory
        for mineral in inventory:
            if robots[mineral] == 0:
                continue
            print(f"{robots[mineral]} {mineral}-collecting robots collect {robots[mineral]} {mineral}; ", end="")
            inventory[mineral] += robots[mineral]
            print(f"you now have {inventory[mineral]} {mineral}.")


        # Add built robots to list
        if robot:
            robots[robot] += 1
            print(f"The new {robot} robot is ready; you now have {robots[robot]} of them.")
        print()

    return inventory["geode"]


def max_geodes(blueprint, minutes):
    quality_level = [0]
    trace = []
    quality_level_recursion(
        blueprint,
        {"ore": 1, "clay": 0, "obsidian": 0, "geode": 0},
        {"ore": 0, "clay": 0, "obsidian": 0, "geode": 0},
        quality_level, 1, minutes, trace
    )
    return quality_level[0]


def quality_level_recursion(blueprint, robots, inventory, quality_level, minute, minutes, trace):
    minutes_remaining = minutes - minute + 1
    # If 24 minutes have passed, calculate quality level
    if minutes_remaining <= 0:
        if inventory["geode"] > quality_level[0]:
            quality_level[0] = inventory["geode"]
        return
    
    # If cant overcome max then return
    max_possible = inventory["geode"] + minutes_remaining / 2 * (2 * robots["geode"] + minutes_remaining - 1)
    if max_possible <= quality_level[0]:
        return
    
    # If we did not build a robot last turn but we could have, dont attempt to build it
    could_build = []
    if len(trace) > 0 and trace[-1] == None:
        for mineral in robots:
            inventory[mineral] -= robots[mineral]
        for robot in robots:
            if can_build(robot, blueprint, inventory):
                could_build.append(robot)
        for mineral in robots:
            inventory[mineral] += robots[mineral]
    
    if minute == minutes:
        should_build = []
    elif minute == minutes - 1:
        should_build = ["geode"]
    elif minute == minutes - 2:
        should_build = ["geode", "obsidian", "ore"]
    else:
        should_build = ["geode", "obsidian", "clay", "ore"]

    # Determine if a new_robot can be built
    to_build = []
    for robot in robots:
        if robot not in could_build and robot in should_build and can_build(robot, blueprint, inventory):
            to_build.append(robot)
    
    # Robots do their thing
    for mineral in robots:
        inventory[mineral] += robots[mineral]
    
    # Consider producing the new robot
    for new_robot in to_build:
        for mineral, amount in blueprint[new_robot].items():
                inventory[mineral] -= amount
        robots[new_robot] += 1
        trace.append(new_robot)
        quality_level_recursion(blueprint, robots, inventory, quality_level, minute + 1, minutes, trace)
        trace.pop()
        robots[new_robot] -= 1
        for mineral, amount in blueprint[new_robot].items():
                inventory[mineral] += amount
    
    # Consider not producing a new robot
    trace.append(None)
    quality_level_recursion(blueprint, robots, inventory, quality_level, minute + 1, minutes, trace)
    trace.pop()
    
    # Undo all changes done before backtracking
    for mineral in robots:
        inventory[mineral] -= robots[mineral]

def part1(blueprints):
    return sum(i * max_geodes(blueprint, 24) for i, blueprint in blueprints.items())

def part2(blueprints):
    return max_geodes(blueprints[1], 32) * max_geodes(blueprints[2], 32) * max_geodes(blueprints[3], 32)
    

if __name__ == '__main__':
    blueprints = read_input()
    print("Part 1:", part1(blueprints))
    print("Part 2:", part2(blueprints))