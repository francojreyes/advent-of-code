import java.util.function.UnaryOperator;

public class Part1Item implements Item {
    int worry;
    int inspected = 0;

    public Part1Item(int worry) {
        this.worry = worry;
    }

    public void inspect(UnaryOperator<Integer> operation) {
        inspected++;
        worry = operation.apply(worry);
        worry /= 3;
    }

    public int getWorry(int mod) {
        return worry % mod;
    }
}