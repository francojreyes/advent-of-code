
public class File implements Inode {
    
    private Directory parent;
    private String name;
    private int size;

    public File(Directory parent, String name, int size) {
        this.parent = parent;
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
    public Directory getParent() {
        return parent;
    }
    
}
