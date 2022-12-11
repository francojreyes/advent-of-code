import java.util.LinkedList;
import java.util.List;
import java.util.Queue;
import java.util.function.Predicate;
import java.util.function.UnaryOperator;

public class Monkey {
    private Queue<Item> items = new LinkedList<>();
    private UnaryOperator<Integer> operation;
    private Predicate<Integer> test;
    private int ifTrue;
    private int ifFalse;
    private int inspected = 0;

    public Monkey(UnaryOperator<Integer> operation, Predicate<Integer> test, int ifTrue, int ifFalse) {
        this.operation = operation;
        this.test = test;
        this.ifTrue = ifTrue;
        this.ifFalse = ifFalse;
    }

    public void addItem(Item item) {
        items.add(item);
    }

    public boolean hasItems() {
        return !items.isEmpty();
    }

    public void throwItem(List<Monkey> monkeys) {
        Item item = items.poll();
        inspected++;
        item.inspect(operation);

        if (test.test(item.getWorry())) {
            monkeys.get(ifTrue).addItem(item);
        } else {
            monkeys.get(ifFalse).addItem(item);
        }
    }

    public int getInspected() {
        return inspected;
    }
    
}
