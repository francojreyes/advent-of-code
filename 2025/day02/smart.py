res = 0
ranges = [tuple(range.split("-", maxsplit=1)) for range in input().split(",")]

for start, end in ranges:
    # Find all even lengths between the two numbers lengths
    for length in range(len(start) + (len(start) % 2), len(end) + 1, 2):
        # If either number is too short/long, use the min/max n-digit value
        clamped_start = int(start) if len(start) >= length else 10 ** (length - 1)
        clamped_end = int(end) if len(end) <= length else 10 ** length - 1
        
        # The valid range of the repeated number is between the first half of each
        half_power_of_10 = 10 ** (length // 2)
        min_repeated_number = clamped_start // half_power_of_10
        max_repeated_number = clamped_end // half_power_of_10

        # If repeating the number at either endpoint is invalid, reduce range
        if min_repeated_number < clamped_start % half_power_of_10:
            min_repeated_number += 1
        if max_repeated_number > clamped_end % half_power_of_10:
            max_repeated_number -= 1

        # All numbers in this range (if any) are invalid IDs when repeated
        for repeated_number in range(min_repeated_number, max_repeated_number + 1):
            res += repeated_number * half_power_of_10 + repeated_number

print(res)        
