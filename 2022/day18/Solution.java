import java.util.Arrays;
import java.util.Scanner;

public class Solution {
    public static void main(String[] args) {
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
        System.out.println(droplet.getSurfaceArea());
    }
}
