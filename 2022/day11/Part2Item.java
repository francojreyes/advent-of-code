import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.function.UnaryOperator;

public class Part2Item implements Item {
    private int initialWorry;
    private Map<Integer, Integer> worryByMod = new HashMap<>();

    public Part2Item(int worry) {
        this.initialWorry = worry;
    }

    public void inspect(UnaryOperator<Integer> operation) {
        for (int modulo : worryByMod.keySet()) {
            worryByMod.compute(modulo, (k, v) -> operation.apply(v) % k);
        }
    }

    public int getWorry(int mod) {
        return worryByMod.get(mod);
    }

    public void trackModuli(List<Integer> moduli) {
        for (int modulo : moduli) {
            worryByMod.put(modulo, initialWorry % modulo);
        }
    }
}