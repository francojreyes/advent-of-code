import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;
import java.util.Queue;
import java.util.Scanner;
import java.util.Set;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import java.util.stream.Collectors;

public class Day16Part2 {

    public static final String REGEX = "([A-Z]{2})|(\\d+)";
    public static final int MINUTES = 26;

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
        Graph g, Map<String, Map<String, Integer>> distances, List<String> items,
        List<String> perm1, int dist1, List<String> perm2, int dist2,
        int[] max, List<List<String>> maxPerm, Set<List<List<String>>> perms
    ) {
        int recursions = 0;

        // Extend the first permutation
        for (int i = 0; i < items.size(); i++) {
            String item = items.remove(0);
            perm1.add(item);
            int nextDist = dist1 + distances.get(perm1.get(perm1.size() - 2)).get(perm1.get(perm1.size() - 2)) + 1;
            if (nextDist < MINUTES) {
                recursions++;
                findMaxPerm(g, distances, items, perm1, nextDist, perm2, dist2, max, maxPerm, perms);
            }
            perm1.remove(perm1.size() - 1);
            items.add(item);
        }

        // Extend the second permutation
        for (int i = 0; i < items.size(); i++) {
            String item = items.remove(0);
            perm2.add(item);
            int nextDist = dist2 + distances.get(perm2.get(perm2.size() - 2)).get(perm2.get(perm2.size() - 2)) + 1;
            if (nextDist < MINUTES) {
                recursions++;
                findMaxPerm(g, distances, items, perm1, dist1, perm2, nextDist, max, maxPerm, perms);
            }
            perm2.remove(perm2.size() - 1);
            items.add(item);
        }

        if (recursions == 0) {
            List<List<String>> perm = List.of(new ArrayList<>(perm1), new ArrayList<>(perm2));
            if (perms.contains(perm));
            perms.add(perm);
            int value = calculateValue(g, perm1, perm2, distances);
            if (value > max[0]) {
                max[0] = value;
                maxPerm.clear();
                maxPerm.addAll(perm);
            }
        }
    }

    public static <E> void swap(List<E> a, int i, int j) {
        E tmp = a.get(i);
        a.set(i, a.get(j));
        a.set(j, tmp);
    }

    public static int calculateValue(Graph g, List<String> perm1, List<String> perm2, Map<String, Map<String, Integer>> distances) {
        int value = 0;
        
        int dist = 0;
        for (int i = 1; i < perm1.size(); i++) {
            dist += distances.get(perm1.get(i - 1)).get(perm1.get(i)) + 1;
            value += (MINUTES - dist) * g.getValue(perm1.get(i));
        }

        dist = 0;
        for (int i = 1; i < perm2.size(); i++) {
            dist += distances.get(perm2.get(i - 1)).get(perm2.get(i)) + 1;
            value += (MINUTES - dist) * g.getValue(perm2.get(i));
        }

        return value;
    }

    public static void main(String[] args) {
        // // Read graph
        Graph g = readInput();
        Map<String, Map<String, Integer>> dist = calculateDistancesMap(g);
        List<String> significantValves = new LinkedList<>(g.getNodes().stream().filter(n -> g.getValue(n) > 0).collect(Collectors.toList()));

        int[] max = {0};
        List<List<String>> maxPerm = new ArrayList<>();
        findMaxPerm(g, dist, significantValves, new ArrayList<>(List.of("AA")), 0, new ArrayList<>(List.of("AA")), 0, max, maxPerm, new HashSet<>());
        
        System.out.println(maxPerm);
        System.out.println(max[0]);
     
    }
}
