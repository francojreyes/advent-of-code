import java.util.Arrays;
import java.util.ArrayList;
import java.util.List;
import java.util.Scanner;
import java.util.Stack;

public class Solution {

    private static final String REGEX = ",|((?<=\\[|\\])|(?=\\[|\\]))";

    private static final String DIVIDER1 = "[[2]]";
    private static final String DIVIDER2 = "[[6]]";

    public static ListValue parsePacket(String line) {
        // Split into "[", "]" or numbers
        List<String> tokens = new ArrayList<>(Arrays.asList(line.split(REGEX)));
        tokens.removeIf(String::isBlank);

        // Create the outermost list and remove the "[" token representing its start
        ListValue outer = new ListValue();
        tokens.remove(0);

        // Create a stack to represent the 'currently open' lists
        Stack<ListValue> stack = new Stack<>();
        stack.add(outer);

        for (String token : tokens) {
            switch (token) {
                case "[":
                    // Open a new list
                    stack.add(new ListValue());
                    break;
                case "]":
                    // Close the current list and add it to the one above (if there is one)
                    ListValue finishedList = stack.pop();
                    if (!stack.isEmpty()) {
                        stack.peek().addValue(finishedList);
                    }
                    break;
                default:
                    // Add the integer to the current list
                    stack.peek().addValue(new IntegerValue(Integer.parseInt(token)));
                    break;
            }
        }

        return outer;
    }

    public static void part1() {
        int sum = 0, idx = 1;
        Scanner scanner = new Scanner(System.in);
        while (scanner.hasNextLine()) {
            // Read the pair in
            ListValue left = parsePacket(scanner.nextLine().strip());
            ListValue right = parsePacket(scanner.nextLine().strip());

            // If in order, add index
            if (left.compareTo(right) <= 0) {
                sum += idx;
            }
            idx++;

            // Possibly read a newline
            if (scanner.hasNextLine())
                scanner.nextLine();
        }
        scanner.close();
        System.out.println(sum);
    }

    public static void part2() {
        // Create the two dividers and a list containing them
        List<ListValue> dividers = List.of(
                parsePacket(DIVIDER1), parsePacket(DIVIDER2));
        List<ListValue> packets = new ArrayList<>(dividers);

        // Read all lines into the list
        Scanner scanner = new Scanner(System.in);
        while (scanner.hasNextLine()) {
            String line = scanner.nextLine().strip();
            if (line.isBlank())
                continue;
            packets.add(parsePacket(line));
        }
        scanner.close();

        // Sort and find indexes of the dividers
        packets.sort(null);
        int decoderKey = dividers
                .stream()
                .mapToInt(d -> packets.indexOf(d) + 1)
                .reduce(1, (a, b) -> a * b);
        System.out.println(decoderKey);
    }

    public static void main(String[] args) {
        // part1();
        part2();
    }
}