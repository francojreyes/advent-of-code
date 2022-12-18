import java.util.LinkedList;
import java.util.List;

public class Cube {

    public static final int SIDES = 6;
    
    private int x;
    private int y;
    private int z;

    public Cube(int x, int y, int z) {
        this.x = x;
        this.y = y;
        this.z = z;
    }

    public List<Cube> adjacentCubes() {
        return new LinkedList<>() {{
            add(new Cube(x + 1, y, z));
            add(new Cube(x - 1, y, z));
            add(new Cube(x, y + 1, z));
            add(new Cube(x, y - 1, z));
            add(new Cube(x, y, z + 1));
            add(new Cube(x, y, z - 1));
        }};
    }

    @Override
    public int hashCode() {
        final int prime = 31;
        int result = 1;
        result = prime * result + x;
        result = prime * result + y;
        result = prime * result + z;
        return result;
    }

    @Override
    public boolean equals(Object obj) {
        if (this == obj) return true;
        if (obj == null) return false;
        if (getClass() != obj.getClass()) return false;
    
        Cube other = (Cube) obj;
        return x == other.x && y == other.y && z == other.z;
    }

    @Override
    public String toString() {
        return x + "," + y + "," + z;
    }

    public int getX() {
        return x;
    }

    public int getY() {
        return y;
    }

    public int getZ() {
        return z;
    }

}