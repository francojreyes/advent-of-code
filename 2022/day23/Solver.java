import java.io.File;
import java.io.FileNotFoundException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;
import java.util.Scanner;
import java.util.Set;
import java.util.stream.Collectors;

public class Solver {

    private static final int END_ROUND = 10;

    private List<Direction> priority;
    private List<Elf> elves = new ArrayList<>();
    
    public Solver(String input) throws FileNotFoundException {
        Scanner scanner = new Scanner(new File(input));
        int i = 0;
        while (scanner.hasNextLine()) {
            String line = scanner.nextLine();
            int j = 0;
            for (char c : line.toCharArray()) {
                if (c == '#') {
                    elves.add(new Elf(new Position(i, j)));
                }
                j++;
            }
            i++;
        }
        scanner.close();
        resetPriority();
    }

    public int part1() {
        resetPriority();

        // Simulate movement
        for (int i = 0; i < END_ROUND; i++) {
            simulateMovement();
        }

        // Count empty tiles
        Position[] bounds = getBoundingPositions();
        return (bounds[1].getX() - bounds[0].getX() + 1) * (bounds[1].getY() - bounds[0].getY() + 1) - elves.size();
    }

    public int part2() {
        resetPriority();

        int i = 1;
        while (simulateMovement() != 0) {
            i++;
        }
        return i;
    }

    private int simulateMovement() {
        int numMoves = 0;

        // Get each elves proposal
        Map<Position, List<Elf>> proposals = new HashMap<>();
        Set<Position> currPositions = elfPositions();
        for (Elf e : elves) {
            Position proposed = e.proposeMove(currPositions, priority);
            if (!proposed.equals(e.getPos())) {
                proposals.computeIfAbsent(proposed, k -> new ArrayList<>()).add(e);
            }
        }

        // Move if only elf
        for (Position p : proposals.keySet()) {
            if (proposals.get(p).size() == 1) {
                proposals.get(p).get(0).setPos(p);
                numMoves++;
            }
        }

        updatePriority();
        return numMoves;
    }

    private Position[] getBoundingPositions() {
        int xMin, xMax, yMin, yMax;
        xMin = yMin = Integer.MAX_VALUE;
        xMax = yMax = Integer.MIN_VALUE;

        for (Position p : elfPositions()) {
            if (p.getX() < xMin) xMin = p.getX();
            if (p.getX() > xMax) xMax = p.getX();
            if (p.getY() < yMin) yMin = p.getY();
            if (p.getY() > yMax) yMax = p.getY();
        }

        return new Position[] {new Position(xMin, yMin), new Position(xMax, yMax)};
    }

    private Set<Position> elfPositions() {
        return elves.stream().map(Elf::getPos).collect(Collectors.toSet());
    }

    private void resetPriority() {
        this.priority = new LinkedList<>(Arrays.asList(Direction.values()));
    }

    private void updatePriority() {
        priority.add(priority.remove(0));
    }

    public void printElves() {
        Set<Position> elfPositions = elfPositions();
        Position[] bounds = getBoundingPositions();
        for (int i = bounds[0].getX(); i <= bounds[1].getX(); i++) {
            for (int j = bounds[0].getY(); j <= bounds[1].getY(); j++) {
                System.out.print(elfPositions.contains(new Position(i, j)) ? '#' : '.');
            }
            System.out.println();
        }
        System.out.println();
    }

    public static void main(String[] args) throws FileNotFoundException {
        System.out.println("Part 1: " +  new Solver(args[0]).part1());
        System.out.println("Part 2: " +  new Solver(args[0]).part2());
    }
}
