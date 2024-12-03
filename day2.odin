package main

import "core:fmt"
import "core:math"
import "core:os"
import "core:slice"
import "core:strconv"
import "core:strings"

Tendency :: enum {
	UNKNOWN,
	INC,
	DEC,
}

main :: proc() {
	bytes, ok := os.read_entire_file("day2_input.txt")
	if !ok {
		fmt.println("Error reading file")
		os.exit(1)
	}

	data := string(bytes)

	safe_reports := 0
	for line in strings.split_lines_iterator(&data) {
		num_arr := strings.split(line, " ")

		safe := true
		tendency: Tendency = .UNKNOWN

		previous_num, _ := strconv.parse_int(num_arr[0])

		for str_num in num_arr[1:] {
			num, ok := strconv.parse_int(str_num)

			defer previous_num = num

			if num == previous_num || math.abs(num - previous_num) > 3 {
				safe = false
				break
			}

			if tendency == .UNKNOWN {
				tendency = .DEC if num < previous_num else .INC
				continue
			}

			if (num < previous_num && tendency != .DEC) ||
			   (num > previous_num && tendency != .INC) {
				safe = false
				break
			}
		}

		if safe {
			safe_reports += 1
		}
	}
	fmt.println("safe reports count:", safe_reports)

}
