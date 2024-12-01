package day02;

import java.util.Arrays;
import java.util.List;
import java.util.Scanner;
import java.util.stream.Collectors;

public class CubeConundrum {
    private static class Draw {
        private int red = 0;
        private int green = 0;
        private int blue = 0;

        Draw(String s) {
            String[] subsets = s.split(", ");
            for (String subset : subsets) {
                String[] numClr = subset.split(" ");
                if (numClr[1].equals("red")) {
                    red = Integer.parseInt(numClr[0]);
                } else if (numClr[1].equals("green")) {
                    green = Integer.parseInt(numClr[0]);
                } else {
                    blue = Integer.parseInt(numClr[0]);
                }
            }
        }

        boolean isPossible() {
            return this.red <= 12 && this.green <= 13 && this.blue <= 14;
        }
    }

    private static class Game {
        private int id;
        private final List<Draw> draws;

        Game(String s) {
            String[] idDraws = s.split(": ");
            this.id = Integer.parseInt(idDraws[0].split(" ")[1]);
            this.draws = Arrays.stream(idDraws[1].split("; "))
                    .map(Draw::new)
                    .collect(Collectors.toList());
        }

        boolean isPossible() {
            return draws.stream().allMatch(Draw::isPossible);
        }

        int power() {
            int minRed = 0;
            int minBlue = 0;
            int minGreen = 0;
            for (Draw draw : draws) {
                minRed = Math.max(minRed, draw.red);
                minBlue = Math.max(minBlue, draw.blue);
                minGreen = Math.max(minGreen, draw.green);
            }

            return minRed * minBlue * minGreen;
        }
    }

    public static void main(String[] args) {
        long sum = 0;
        Scanner scanner = new Scanner(System.in);

        while (scanner.hasNextLine()) {
            String line = scanner.nextLine();
            Game game = new Game(line);

            // part 1
            // if (game.isPossible()) {
            //     sum += game.id;
            // }

            // part 2
            sum += game.power();
        }

        System.out.println(sum);
    }
}
