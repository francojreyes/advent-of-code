import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.List;
import java.util.Scanner;
import java.util.Stack;
import java.util.regex.Pattern;

public class Solution {

    public static List<Stack<Character>> readStacks(Scanner scanner) {
        List<Stack<Character>> stacks = new ArrayList<>();
        while (true) {
            String line = scanner.nextLine();

            // If it's all numbers, break because that's the end of the stacks
            Pattern numbers = Pattern.compile("^[\\s\\d]*$");
            if (numbers.matcher(line).find()) {
                break;
            }

            for (int i = 0; 4 * i < line.length(); i++) {
                // The first loop should initialise each stack
                if (stacks.size() < i + 1) {
                    stacks.add(new Stack<>());
                }

                // The important characters start at index 1 and are 3 spaces apart
                char c = line.charAt(4 * i + 1);
                if (c != ' ') {
                    stacks.get(i).add(c);
                }
            }
        }

        // We added them from the top, so reverse now
        stacks.forEach(stack -> Collections.reverse(stack));
        return stacks;
    }

    public static void CrateMover9000(int num, Stack<Character> from, Stack<Character> to) {
        for (int i = 0; i < num; i++) {
            to.push(from.pop());
        }
    }

    public static void CrateMover9001(int num, Stack<Character> from, Stack<Character> to) {
        Stack<Character> temp = new Stack<>();
        for (int i = 0; i < num; i++) {
            temp.push(from.pop());
        }
        for (int i = 0; i < num; i++) {
            to.push(temp.pop());
        }
    }

    public static void main(String[] args) {
        Scanner scanner = new Scanner(System.in);
        List<Stack<Character>> stacks = readStacks(scanner);
        while (scanner.hasNextLine()) {
            String instruction = scanner.nextLine();
            if (instruction.isBlank()) continue;

            // Extract the numbers from the instruction
            int[] nums = Arrays.asList(instruction.split("\\D+"))
                .stream()
                .skip(1)
                .mapToInt(num -> Integer.parseInt(num))
                .toArray();
            
            // Use either the CrateMover9000 or CreateMover9001
            CrateMover9001(nums[0], stacks.get(nums[1] - 1), stacks.get(nums[2] - 1));
        }
        
        scanner.close();
        stacks.forEach(stack -> System.out.print(stack.peek()));
        System.out.println();
    }
}
