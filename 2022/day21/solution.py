import re
from collections import defaultdict
from sys import stdin

OPERATIONS = {
    "+": lambda a, b: a + b,
    "-": lambda a, b: a - b,
    "*": lambda a, b: a * b,
    "/": lambda a, b: a // b
}


def evaluate(monkey, values, dependencies, operations, dependents):
    if monkey in values:
        return

    lhs, rhs = dependencies[monkey]
    if lhs not in values or rhs not in values:
        return

    values[monkey] = OPERATIONS[operations[monkey]](values[lhs], values[rhs])

    if monkey in dependents:
        for dependent in dependents[monkey]:
            evaluate(dependent, values, dependencies, operations, dependents)


def depends_on_humn(monkey, dependencies):
    if monkey == "humn":
        return True

    if monkey not in dependencies:
        return False

    lhs, rhs = dependencies[monkey]
    if lhs == "humn" or rhs == "humn":
        return True

    return depends_on_humn(lhs, dependencies) or depends_on_humn(rhs, dependencies)


def match_humn(monkey, dependencies, operations, target):
    if monkey == "humn":
        return target

    lhs, rhs = dependencies[monkey]
    if depends_on_humn(lhs, dependencies):
        fixed, var = rhs, lhs
    else:
        fixed, var = lhs, rhs

    fixed_value = values[fixed]
    match operations[monkey]:
        case "+":
            next_target = target - fixed_value
        case "-":
            if fixed == lhs:
                next_target = fixed_value - target
            else:
                next_target = target + fixed_value
        case "*":
            next_target = target // fixed_value
        case "/":
            if fixed == lhs:
                next_target = fixed_value // target
            else:
                next_target = target * fixed_value

    return match_humn(var, dependencies, operations, next_target)


if __name__ == '__main__':
    values = {}
    dependencies = {}
    operations = {}
    dependents = defaultdict(lambda: [])
    for line in stdin:
        args = re.split(":?\s+", line)
        monkey = args[0]
        if args[1].isnumeric():
            values[monkey] = int(args[1])
            if monkey in dependents:
                for dependent in dependents[monkey]:
                    evaluate(dependent, values, dependencies,
                             operations, dependents)
        else:
            dependencies[monkey] = (args[1], args[3])
            operations[monkey] = args[2]
            dependents[args[1]].append(monkey)
            dependents[args[3]].append(monkey)
            evaluate(monkey, values, dependencies, operations, dependents)

        # Part 1
        # if "root" in values:
        #     print(values["root"])
        #     break

    lhs, rhs = dependencies["root"]
    if depends_on_humn(lhs, dependencies):
        print(match_humn(lhs, dependencies, operations, values[rhs]))
    else:
        print(match_humn(rhs, dependencies, operations, values[lhs]))
