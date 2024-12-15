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
	bytes := #load("../input_data/day2_input.txt")

	data := string(bytes)

	safe_reports := 0
	safe_reports_dampener := 0

	for line in strings.split_lines_iterator(&data) {
		num_arr := strings.split(line, " ")
		level: [dynamic]int
		defer delete(level)

		for str_num in num_arr {
			num, ok := strconv.parse_int(str_num)
			assert(ok)
			append(&level, num)
		}

		if is_level_safe(level) {
			safe_reports += 1
		} else {
			for i in 0 ..< len(level) {
				level_without_one := make([dynamic]int)
				defer clear_dynamic_array(&level_without_one)

				for j in 0 ..< len(level) {
					if i != j {
						append(&level_without_one, level[j])
					}
				}

				if is_level_safe(level_without_one) {
					safe_reports_dampener += 1
					break
				}
			}
		}
	}
	fmt.println("safe reports count:", safe_reports)
	fmt.println("safe reports count with dampener:", safe_reports + safe_reports_dampener)
}


is_level_safe :: proc(level: [dynamic]int) -> bool {
	tendency: Tendency = .UNKNOWN
	previous_num := level[0]

	for num in level[1:] {

		defer previous_num = num

		if num == previous_num || math.abs(num - previous_num) > 3 {
			return false
		}

		if tendency == .UNKNOWN {
			tendency = .DEC if num < previous_num else .INC
			continue
		}

		if (num < previous_num && tendency != .DEC) || (num > previous_num && tendency != .INC) {
			return false
		}
	}
	return true

}
