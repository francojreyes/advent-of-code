import java.util.HashMap;
import java.util.Map;

public class Directory implements Inode {
        
    private Directory parent;
    private String name;
    Map<String, Inode> files = new HashMap<>();

    public Directory(Directory parent, String name) {
        this.parent = parent;
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

    public void addChild(Inode inode) {
        files.put(inode.getName(), inode);
    }

    public Map<String, Inode> getChildren() {
        return files;
    }

    @Override
    public Directory getParent() {
        return parent;
    }
    
}
