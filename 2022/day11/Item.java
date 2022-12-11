import java.util.function.UnaryOperator;

public interface Item {
    public void inspect(UnaryOperator<Integer> operation);
    public int getWorry(int mod);
}
