from math import ceil
import re
from sys import stdin

DELIM = r":|\."
NUM = r"\d+"

MINUTES = 24

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


def quality_level_brute_force(blueprint):
    quality_level = [0]
    trace = []
    quality_level_recursion(
        blueprint,
        {"ore": 1, "clay": 0, "obsidian": 0, "geode": 0},
        {"ore": 0, "clay": 0, "obsidian": 0, "geode": 0},
        quality_level, 1, trace
    )
    return quality_level[0]


def quality_level_recursion(blueprint, robots, inventory, quality_level, minute, trace):
    # If 24 minutes have passed, return
    if minute > MINUTES:
        if inventory["geode"] > quality_level[0]:
            quality_level[0] = inventory["geode"]
        return

    # Determine if a new_robot can be built
    buildable = []
    for robot in ["geode", "obsidian", "clay", "ore"]:
        if can_build(robot, blueprint, inventory):
            buildable.append(robot)
    
    # Robots do their thing
    for mineral in robots:
        inventory[mineral] += robots[mineral]
    
    # Consider producing the new robot
    for new_robot in buildable:
        for mineral, amount in blueprint[new_robot].items():
                inventory[mineral] -= amount
        robots[new_robot] += 1
        trace.append(new_robot)
        quality_level_recursion(blueprint, robots, inventory, quality_level, minute + 1, trace)
        trace.pop()
        robots[new_robot] -= 1
        for mineral, amount in blueprint[new_robot].items():
                inventory[mineral] += amount
    
    # Consider not producing a new robot
    trace.append(None)
    quality_level_recursion(blueprint, robots, inventory, quality_level, minute + 1, trace)
    trace.pop()
    
    # Undo all changes done before backtracking
    for mineral in robots:
        inventory[mineral] -= robots[mineral]
    

if __name__ == '__main__':
    blueprints = read_input()

    for i in blueprints:
        print(i, quality_level_brute_force(blueprints[i]))
    # print(sum(ID * quality_level(blueprint) for ID, blueprint in blueprints.items()))