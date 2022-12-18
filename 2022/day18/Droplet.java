import java.util.HashMap;
import java.util.HashSet;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;
import java.util.Set;

/**
 * Lowkey union find data structure
 */
public class Droplet {

    private Map<Cube, Cube> labels = new HashMap<>();
    private Map<Cube, Integer> surfaceAreas = new HashMap<>();
    private Map<Cube, List<Cube>> sets = new HashMap<>();

    public void addCube(Cube c) {
        // Create a new set for this cube
        labels.put(c, c);
        surfaceAreas.put(c, Cube.SIDES);
        sets.put(c, new LinkedList<>() {{
            add(c);
        }});

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
        // System.out.println(mergeTarget + " now has SA " + surfaceAreas.get(mergeTarget));
    }

    // Merge the set with label s and the set with label t
    // Return the label of the set that was merged into
    private Cube merge(Cube s, Cube t) {
        // System.out.println("Merging " + s + " and " + t);
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
}
