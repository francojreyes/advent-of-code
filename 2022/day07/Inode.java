import java.util.Map;

/**
 * Composite pattern
 */
public interface Inode {
    public String getName();
    public int getSize();
    public void addChild(Inode inode);
    public Map<String, Inode> getChildren();
    public void setParent(Directory parent);
    public Directory getParent();
 }
