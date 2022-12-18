import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.stream.Collectors;

public class Graph {
    
    private Map<String, Integer> nodes = new LinkedHashMap<>();
    private Map<String, Set<String>> adjacent = new HashMap<>();

    public void addNode(String label, int value) {
        nodes.put(label, value);
        adjacent.put(label, new HashSet<>());
    }

    public List<String> getNodes() {
        return new ArrayList<>(nodes.keySet());
    }

    public int getValue(String label) {
        return nodes.containsKey(label) ? nodes.get(label) : 0;
    }

    public void addEdge(String from, String to) {
        adjacent.get(from).add(to);
        adjacent.get(to).add(from);
    }

    public List<String> adjacentNodes(String label) {
        return new ArrayList<>(adjacent.get(label));
    }

    @Override
    public String toString() {
        return String.join("\n", getNodes()
            .stream()
            .map(node -> node + " " + getValue(node) + " " + adjacentNodes(node))
            .collect(Collectors.toList())
        );
    }

}
