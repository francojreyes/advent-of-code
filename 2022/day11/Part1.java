import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.List;
import java.util.Scanner;
import java.util.function.UnaryOperator;
import java.util.stream.Collectors;

public class Part1 {

    private static final int NUM_ROUNDS = 20;

    public static List<Monkey> readInput() {
        List<Monkey> monkeys = new ArrayList<>();

        Scanner scanner = new Scanner(System.in);
        while (scanner.hasNextLine()) {
            String line;
            String[] split;

            // New monkey
            scanner.nextLine();

            // Items
            line = scanner.nextLine();
            List<Part1Item> items = Arrays.asList(line.strip().replace("Starting items: ", "").split(", "))
                    .stream()
                    .map(Integer::parseInt)
                    .map(Part1Item::new)
                    .collect(Collectors.toList());
            
            // Operation
            line = scanner.nextLine();
            split = line.split("\\s+");
            UnaryOperator<Integer> operation = null;
            if (split[split.length - 1].equals("old")) {
                switch (split[split.length - 2]) {
                    case "*":
                        operation = i -> i * i;
                        break;
                    case "+":
                        operation = i -> i + i;
                        break;
                }
            } else {
                int arg = Integer.parseInt(split[split.length - 1]);
                switch (split[split.length - 2]) {
                    case "*":
                        operation = i -> i * arg;
                        break;
                    case "+":
                        operation = i -> i + arg;
                        break;
                }
            }

            // Test
            line = scanner.nextLine();
            split = line.split("\\s+");
            int base = Integer.parseInt(split[split.length - 1]);

            // Throw if true
            line = scanner.nextLine();
            split = line.split("\\s+");
            int ifTrue = Integer.parseInt(split[split.length - 1]);

            // Throw if false
            line = scanner.nextLine();
            split = line.split("\\s+");
            int ifFalse = Integer.parseInt(split[split.length - 1]);

            Monkey monkey = new Monkey(operation, base, ifTrue, ifFalse);
            items.forEach(monkey::addItem);
            monkeys.add(monkey);

            // Possibly read a new line
            if (scanner.hasNextLine()) scanner.nextLine();
        }

        scanner.close();
        return monkeys;
    }

    public static void main(String[] args) {
        List<Monkey> monkeys = readInput();

        for (int i = 0; i < NUM_ROUNDS; i++) {
            for (Monkey monkey : monkeys) {
                while (monkey.hasItems()) {
                    monkey.throwItem(monkeys);
                }
            }
        }

        List<Long> inspections = monkeys
                .stream()
                .map(Monkey::getInspected)
                .collect(Collectors.toList());
        
        Collections.sort(inspections, Collections.reverseOrder());
        System.out.println(inspections.get(0) * inspections.get(1));
    }
    
}
