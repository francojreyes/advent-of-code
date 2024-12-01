package day01;

import java.util.*;
import java.util.regex.Pattern;
import java.util.regex.Matcher;

public class Trebuchet {
    public static void main(String[] args) {
        Map<String, Integer> wordToInt = new HashMap<>() {{
            put("one", 1);
            put("two", 2);
            put("three", 3);
            put("four", 4);
            put("five", 5);
            put("six", 6);
            put("seven", 7);
            put("eight", 8);
            put("nine", 9);
        }};

        int sum = 0;
        Scanner scanner = new Scanner(System.in);
        Pattern pattern = Pattern.compile("one|two|three|four|five|six|seven|eight|nine|\\d");

        while (scanner.hasNextLine()) {
            String line = scanner.nextLine();
            Matcher matcher = pattern.matcher(line);
            List<Integer> nums = new ArrayList<>();

            if (matcher.find()) {
                do {
                    String val = matcher.group();
                    if (wordToInt.containsKey(val)) {
                        nums.add(wordToInt.get(val));
                    } else {
                        nums.add(Integer.parseInt(val));
                    }
                } while (matcher.find(matcher.start() + 1));
            }

            System.err.println(nums);
            sum += 10 * nums.get(0) + nums.get(nums.size() - 1);
        }

        System.out.println(sum);
    }
}