import java.util.LinkedList;
import java.util.List;
import java.util.Queue;
import java.util.function.UnaryOperator;

public class Monkey {
    private Queue<Item> items = new LinkedList<>();
    private UnaryOperator<Integer> operation;
    private int mod;
    private int ifTrue;
    private int ifFalse;
    private long inspected = 0;

    public Monkey(UnaryOperator<Integer> operation, int mod, int ifTrue, int ifFalse) {
        this.operation = operation;
        this.mod = mod;
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

        if (item.getWorry(mod) == 0) {
            monkeys.get(ifTrue).addItem(item);
        } else {
            monkeys.get(ifFalse).addItem(item);
        }
    }

    public long getInspected() {
        return inspected;
    }
    
}
