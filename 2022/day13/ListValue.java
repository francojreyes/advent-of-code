import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

/**
 * An list, 'compound' node of the Value composite pattern
 */
public class ListValue implements Value {

    private List<Value> values = new ArrayList<>();

    public void addValue(Value v) {
        values.add(v);
    }

    public List<Value> getValues() {
        return new ArrayList<>(values);
    }

    public Value getValue(int index) {
        return values.get(index);
    }

    public int size() {
        return values.size();
    }

    @Override
    public String toString() {
        return "[" + String.join(",", values.stream().map(Object::toString).collect(Collectors.toList())) + "]";
    }

    @Override
    public int compareTo(Value o) {
        if (o instanceof ListValue) {
            // Compare element wise, if all were equal compare size to see which ended first
            ListValue l = (ListValue) o;
            for (int j = 0; j < Math.min(this.size(), l.size()); j++) {
                int cmp = this.getValue(j).compareTo(l.getValue(j));
                if (cmp != 0)
                    return cmp;
            }
            return this.size() - l.size();
        } else {
            // Create a list containing only the other integer to compare to
            IntegerValue i = (IntegerValue) o;
            ListValue dummy = new ListValue();
            dummy.addValue(i);
            return this.compareTo(dummy);
        }
    }

}
