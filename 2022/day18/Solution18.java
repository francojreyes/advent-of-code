import java.util.Arrays;
import java.util.Scanner;

public class Solution18 {

    public static Droplet readInput() {
        Droplet droplet = new Droplet();
        Scanner scanner = new Scanner(System.in);
        while (scanner.hasNextLine()) {
            int[] pos = Arrays.asList(scanner.nextLine().strip().split(","))
                    .stream()
                    .mapToInt(Integer::parseInt)
                    .toArray();
            droplet.addCube(new Cube(pos[0], pos[1], pos[2]));
        }
        scanner.close();
        return droplet;
    }

    public static void main(String[] args) {
        Droplet droplet = readInput();
        System.out.println("Part 1: " + droplet.getSurfaceArea());
        System.out.println("Part 2: " + droplet.getExternalSurfaceArea());
    }
}
