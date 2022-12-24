import java.util.List;
import java.util.Set;

public class Elf {

    private Position pos;

    public Elf(Position pos) {
        this.pos = pos;
    }

    public Position proposeMove(Set<Position> elves, List<Direction> priority) {
        // If no other Elves are in one of those eight positions, the Elf does not do anything during this round.
        if (pos.getAdjacentPositions(null).stream().allMatch(p -> !elves.contains(p))) {
            return pos;
        }

        // Otherwise, the Elf looks in each of four directions and proposes moving one step in the first valid direction
        for (Direction d : priority) {
            if (pos.getAdjacentPositions(d).stream().allMatch(p -> !elves.contains(p))) {
                return pos.getAdjacentPositions(d).get(1);
            }
        }

        // Ig stay still if there's nowhere to go?
        return pos;
    }

    public Position getPos() {
        return pos;
    }

    public void setPos(Position pos) {
        this.pos = pos;
    }

}
