import java.util.Arrays;
import java.util.Scanner;

public class Solution {
    public static void main(String[] args) {
        int num = 0;

        Scanner scanner = new Scanner(System.in);
        while (scanner.hasNextLine()) {
            String line = scanner.nextLine();

            int[] nums = Arrays.asList(line.split("-|,"))
                .stream()
                .mapToInt(n -> Integer.parseInt(n))
                .toArray();

            if (part2(nums)) num++;
        }

        scanner.close();
        System.out.println(num);
    }

    /**
     * @param nums nums[0] and nums[1] are a pair, nums[2] and nums[3] are a pair
     * @return whether one range is completely encompassed by another
     */
    public static boolean part1(int[] nums) {
        return (nums[0] >= nums[2] && nums[1] <= nums[3])
               || (nums[2] >= nums[0] && nums[3] <= nums[1]);
    }

    /**
     * @param nums nums[0] and nums[1] are a pair, nums[2] and nums[3] are a pair
     * @return whether there is ANY overlap in the two ranges
     */
    public static boolean part2(int[] nums) {
        return nums[2] <= nums[1] && nums[3] >= nums[0];

    } 
}
