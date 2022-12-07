import java.util.HashMap;
import java.util.Map;

public class Directory implements Inode {
        
    private Directory parent;
    private String name;
    Map<String, Inode> files = new HashMap<>();

    public Directory(String name) {
        this.name = name;
    }
    
    @Override
    public String getName() {
        return name;
    }

    @Override
    public int getSize() {
        return files.values().stream().mapToInt(Inode::getSize).sum();
    }

    @Override
    public void addChild(Inode inode) {
        files.put(inode.getName(), inode);
        inode.setParent(this);
    }

    @Override
    public Map<String, Inode> getChildren() {
        return files;
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
