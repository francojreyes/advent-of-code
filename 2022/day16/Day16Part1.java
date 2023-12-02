import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;
import java.util.Queue;
import java.util.Scanner;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import java.util.stream.Collectors;

public class Day16Part1 {

    public static final String REGEX = "([A-Z]{2})|(\\d+)";
    public static final int MINUTES = 30;

    public static List<String> allMatches(String str, String pattern) {
        List<String> allMatches = new ArrayList<String>();
        Matcher m = Pattern.compile(pattern).matcher(str);
        while (m.find()) {
            allMatches.add(m.group());
        }
        return allMatches;
    }
    
    public static Graph readInput() {
        Scanner scanner = new Scanner(System.in);
        List<List<String>> parsedLines = new ArrayList<>();
        while (scanner.hasNextLine()) {
            parsedLines.add(allMatches(scanner.nextLine(), REGEX));
        }
        scanner.close();

        Graph g = new Graph();
        for (List<String> parsedLine : parsedLines) {
            g.addNode(parsedLine.get(0), Integer.parseInt(parsedLine.get(1)));
        }
        for (List<String> parsedLine : parsedLines) {
            for (String adj : parsedLine.subList(2, parsedLine.size())) {
                g.addEdge(parsedLine.get(0), adj);
            }
        }

        return g;
    }

    public static Map<String, Map<String, Integer>> calculateDistancesMap(Graph g) {
        Map<String, Map<String, Integer>> result = new HashMap<>();

        for (String node : g.getNodes()) {
            Map<String, Integer> distances = new HashMap<>();
            distances.put(node, 0);

            Queue<String> q = new LinkedList<>();
            q.add(node);
            while (!q.isEmpty()) {
                String n = q.poll();
                for (String adj : g.adjacentNodes(n)) {
                    if (!distances.containsKey(adj)) {
                        distances.put(adj, distances.get(n) + 1);
                        q.add(adj);
                    }
                }
            }

            result.put(node, distances);
        }

        return result;
    }

    public static void findMaxPerm(
        Graph g, List<String> items, Map<String, Map<String, Integer>> distances,
        int depth, int prevDist,
        int[] max, List<String> maxPerm
    ) {
        int recursions = 0;
        for (int i = depth; i < items.size(); i++) {
            swap(items, depth, i);
            int dist = prevDist + distances.get(items.get(depth - 1)).get(items.get(depth)) + 1;
            if (dist < MINUTES) {
                recursions++;
                findMaxPerm(g, items, distances, depth + 1, dist, max, maxPerm);
            }
            swap(items, depth, i);
        }

        if (recursions == 0) {
            int value = calculateValue(g, items.subList(0, depth), distances, false);
            if (value > max[0]) {
                max[0] = value;
                maxPerm.clear();
                maxPerm.addAll(items.subList(0, depth));
            }
            return;
        }
    }

    public static <E> void swap(List<E> a, int i, int j) {
        E tmp = a.get(i);
        a.set(i, a.get(j));
        a.set(j, tmp);
    }

    public static int calculateValue(Graph g, List<String> perm, Map<String, Map<String, Integer>> distances, boolean debug) {
        int dist = 0;
        int value = 0;
        for (int i = 1; i < perm.size(); i++) {
            dist += distances.get(perm.get(i - 1)).get(perm.get(i)) + 1;
            if (debug) 
                System.out.println("Opening valve " + perm.get(i) + " in minute " + dist);
            value += (MINUTES - dist) * g.getValue(perm.get(i));
        }
        return value;
    }

    public static void main(String[] args) {
        // Read graph
        Graph g = readInput();

        Map<String, Map<String, Integer>> dist = calculateDistancesMap(g);

        List<String> significantValves = g.getNodes().stream().filter(n -> g.getValue(n) > 0).collect(Collectors.toList());
        significantValves.add(0, "AA");

        int[] max = {0};
        List<String> maxPerm = new ArrayList<>();
        findMaxPerm(g, significantValves, dist, 1, 0, max, maxPerm);

        System.out.println(maxPerm);
        System.out.println(max[0]);
    }
}
