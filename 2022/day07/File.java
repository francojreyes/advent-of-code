import java.util.HashMap;
import java.util.Map;

public class File implements Inode {
    
    private Directory parent;
    private String name;
    private int size;

    public File(String name, int size) {
        this.name = name;
        this.size = size;
    }

    @Override
    public String getName() {
        return name;
    }

    @Override
    public int getSize() {
        return size;
    }
    @Override
    public void addChild(Inode inode) {
        return;
    }

    @Override
    public Map<String, Inode> getChildren() {
        return new HashMap<>();
    }

    @Override
    public void setParent(Directory parent) {
        this.parent = parent;        
    }

    @Override
    public Directory getParent() {
        return parent;
    }
    
}
