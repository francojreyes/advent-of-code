import java.util.function.UnaryOperator;

public class Item {
    int worry;
    int inspected = 0;

    public Item(int worry) {
        this.worry = worry;
    }

    public void inspect(UnaryOperator<Integer> operation) {
        inspected++;
        worry = operation.apply(worry);
        worry /= 3;
    }

    public int getWorry() {
        return worry;
    }
}