import java.util.HashMap;
import java.util.HashSet;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;
import java.util.Queue;
import java.util.Set;

/**
 * Lowkey union find data structure
 */
public class Droplet {

    private Map<Cube, Cube> labels = new HashMap<>();
    private Map<Cube, Integer> surfaceAreas = new HashMap<>();
    private Map<Cube, List<Cube>> sets = new HashMap<>();

    private int xBound = 0;
    private int yBound = 0;
    private int zBound = 0;

    public void addCube(Cube c) {
        // Create a new set for this cube
        labels.put(c, c);
        surfaceAreas.put(c, Cube.SIDES);
        sets.put(c, new LinkedList<>() {{
            add(c);
        }});

        if (c.getX() > xBound) xBound = c.getX();
        if (c.getY() > yBound) yBound = c.getY();
        if (c.getZ() > zBound) zBound = c.getZ();

        // Find the number and label of attached sets
        Set<Cube> attached = new HashSet<>();
        int numAttachments = 0;
        for (Cube adj : c.adjacentCubes()) {
            if (!labels.containsKey(adj)) continue;
            attached.add(labels.get(adj));
            numAttachments++;
        }
        if (numAttachments == 0) return;

        // Calculate final surface area then merge sets
        int mergedSurfaceArea = attached.stream().mapToInt(surfaceAreas::get).sum() + Cube.SIDES - 2 * numAttachments;
        Cube mergeTarget = c;
        for (Cube label : attached) {
            mergeTarget = merge(mergeTarget, label);
        }
        surfaceAreas.put(mergeTarget, mergedSurfaceArea);
    }

    // Merge the set with label s and the set with label t
    // Return the label of the set that was merged into
    private Cube merge(Cube s, Cube t) {
        // Assign the smaller to src and the larger to dest
        Cube src = sets.get(s).size() < sets.get(t).size() ? s : t;
        Cube dest = src == s ? t : s;

        // Move all elements of src to dest
        List<Cube> srcSet = sets.get(src);
        List<Cube> destSet = sets.get(dest);
        while (!srcSet.isEmpty()) {
            Cube c = srcSet.remove(0);
            labels.put(c, dest);
            destSet.add(c);
        }
        surfaceAreas.put(src, 0);

        return dest;
    }

    public int getSurfaceArea() {
        return surfaceAreas.values().stream().reduce(0, Integer::sum);
    }

    // BFS through space and find all outward facing cubes
    public int getExternalSurfaceArea() {
        int surfaceArea = 0;
        Set<Cube> visited = new HashSet<>();
        Queue<Cube> q = new LinkedList<>();
        q.add(new Cube(-1, -1, -1));
        while (!q.isEmpty()) {
            Cube c = q.poll();
            for (Cube adj : c.adjacentCubes()) {
                if (containsCube(adj)) {
                    surfaceArea++;
                } else if (inBounds(adj) && !visited.contains(adj)) {
                    q.add(adj);
                    visited.add(adj);
                }
            }
        }
        return surfaceArea;
    }

    public boolean containsCube(Cube c) {
        return labels.containsKey(c);
    }

    public boolean inBounds(Cube c) {
        return -1 <= c.getX() && c.getX() <= xBound + 1 &&
               -1 <= c.getY() && c.getY() <= yBound + 1 &&
               -1 <= c.getZ() && c.getZ() <= zBound + 1;
    }

}
