import java.util.List;

public class Position {

    private int x;
    private int y;

    public Position(int x, int y) {
        this.x = x;
        this.y = y;
    }

    public int getX() {
        return x;
    }

    public int getY() {
        return y;
    }

    public List<Position> getAdjacentPositions(Direction d) {
        if (d == null) {
            return List.of(
                new Position(x - 1, y - 1), new Position(x - 1, y), new Position(x - 1, y + 1), new Position(x, y + 1),
                new Position(x + 1, y + 1), new Position(x + 1, y), new Position(x + 1, y - 1), new Position(x, y - 1)
            );
        }

        switch (d) {
            case NORTH: return List.of(new Position(x - 1, y - 1), new Position(x - 1, y), new Position(x - 1, y + 1));
            case EAST:  return List.of(new Position(x - 1, y + 1), new Position(x, y + 1), new Position(x + 1, y + 1));
            case SOUTH: return List.of(new Position(x + 1, y - 1), new Position(x + 1, y), new Position(x + 1, y + 1));
            case WEST:  return List.of(new Position(x - 1, y - 1), new Position(x, y - 1), new Position(x + 1, y - 1));
            default:    return null;
        }
    }

    @Override
    public int hashCode() {
        final int prime = 31;
        int result = 1;
        result = prime * result + x;
        result = prime * result + y;
        return result;
    }

    @Override
    public boolean equals(Object obj) {
        if (this == obj)
            return true;
        if (obj == null)
            return false;
        if (getClass() != obj.getClass())
            return false;
        Position other = (Position) obj;
        if (x != other.x)
            return false;
        if (y != other.y)
            return false;
        return true;
    }

}