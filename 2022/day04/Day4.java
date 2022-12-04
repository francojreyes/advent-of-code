import java.util.Scanner;

public class Day4 {
    public static void main(String[] args) {
        int num = 0;
        Scanner scanner = new Scanner(System.in);
        while (scanner.hasNextLine()) {
            String line = scanner.nextLine();
            String[] nums = line.split("-|,");
            
            int[] parsed = new int[nums.length];
            for (int i = 0; i < nums.length; i++) {
                parsed[i] = Integer.parseInt(nums[i]);
            }

            if (part2(parsed)) num++;
        }
        scanner.close();
        System.out.println(num);
    }

    public static boolean part1(int[] nums) {
        return (nums[0] >= nums[2] && nums[1] <= nums[3])
               || (nums[2] >= nums[0] && nums[3] <= nums[1]);
    }

    public static boolean part2(int[] nums) {
        return (nums[2] <= nums[1] || nums[3] <= nums[1])
               && (nums[2]>= nums[0] || nums[3] >= nums[0]);

    } 
}
