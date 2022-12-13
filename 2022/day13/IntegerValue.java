
/**
 * An integer, 'leaf' node of the Value composite pattern
 */
public class IntegerValue implements Value {

    private int value;

    public IntegerValue(int value) {
        this.value = value;
    }

    public int getValue() {
        return value;
    }

    @Override
    public String toString() {
        return Integer.valueOf(value).toString();
    }

    @Override
    public int compareTo(Value o) {
        if (o instanceof IntegerValue) {
            // Compare integers
            IntegerValue i = (IntegerValue) o;
            return Integer.compare(this.getValue(), i.getValue());
        } else {
            // Create a list containing only this integer to compare the other to
            ListValue l = (ListValue) o;
            ListValue dummy = new ListValue();
            dummy.addValue(this);
            return dummy.compareTo(l);
        }
    }

}
