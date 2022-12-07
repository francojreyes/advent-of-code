import java.util.LinkedList;
import java.util.Queue;
import java.util.Scanner;

public class Solution {

    public static int AVAILABLE = 70000000;
    public static int REQUIRED = 30000000;

    public static Directory readInput() {
        Directory root = new Directory("/");
        Inode cwd = root;

        Scanner scanner = new Scanner(System.in);
        while (scanner.hasNextLine()) {
            String[] line = scanner.nextLine().split("\\s+");

            switch (line[0]) {
                case "$":
                    if (!line[1].equals("cd")) continue;
                    switch (line[2]) {
                        case "/":
                            cwd = root; break;
                        case "..":
                            cwd = cwd.getParent(); break;
                        default:
                            cwd = cwd.getChildren().get(line[2]);
                    }
                    break;
                case "dir":
                    cwd.addChild(new Directory(line[1])); break;
                default:
                    cwd.addChild( new File(line[1], Integer.parseInt(line[0]))); break;
            }
        }
        scanner.close();
        return root;
    }

    public static void part1(Directory root) {
        Queue<Directory> q = new LinkedList<>();
        q.add(root);

        int sum = 0;
        while (!q.isEmpty()) {
            Directory dir = q.poll();
            int size = dir.getSize();
            if (size <= 100000) {
                sum += size;
            }

            for (Inode inode : dir.getChildren().values()) {
                if (inode instanceof Directory) {
                    q.add((Directory) inode);
                }
            }
        }
        System.out.println(sum);
    }

    public static void part2(Directory root) {
        int toDelete = REQUIRED - (AVAILABLE - root.getSize());

        Queue<Directory> q = new LinkedList<>();
        q.add(root);

        // BFS that stops if the directory isnt large enough
        int ceil = AVAILABLE;
        while (!q.isEmpty()) {
            Directory dir = q.poll();
            for (Inode inode : dir.getChildren().values()) {
                if (inode instanceof Directory) {
                    Directory child = (Directory) inode;
                    int size = child.getSize();
                    if (size >= toDelete) {
                        if (size < ceil) {
                            ceil = size;
                        }
                        q.add((Directory) inode);
                    }
                }
            }
        }
        System.out.println(ceil);
    }

    public static void main(String[] args) {
        Directory root = readInput();
        part2(root);
    }
}
