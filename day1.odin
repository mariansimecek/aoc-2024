package main

import "core:fmt"
import "core:math"
import "core:os"
import "core:slice"
import "core:strconv"
import "core:strings"

main :: proc() {
	data, ok := os.read_entire_file("input_data/day1_input.txt")
	if !ok {
		fmt.println("Error reading file")
		os.exit(1)
	}

	data_string := string(data)
	left_arr := [dynamic]int{}
	right_arr := [dynamic]int{}
	difference := 0

	for line in strings.split_lines_iterator(&data_string) {
		res := strings.split(line, "   ")
		assert(len(res) == 2)

		left_side, left_side_ok := strconv.parse_int(res[0])
		right_side, right_side_ok := strconv.parse_int(res[1])
		append(&left_arr, left_side)
		append(&right_arr, right_side)
	}

	slice.sort(left_arr[:])
	slice.sort(right_arr[:])

	assert(len(left_arr) == len(right_arr))

	for index in 0 ..< len(left_arr) {
		difference += math.abs(left_arr[index] - right_arr[index])
	}

	fmt.println("difference:", difference)
	similarity_score := 0

	for a_idx in 0 ..< len(left_arr) {
		for b_idx in 0 ..< len(right_arr) {
			count := 0
			if left_arr[a_idx] == right_arr[b_idx] {
				count += 1
			}
			similarity_score += left_arr[a_idx] * count
		}
	}
	fmt.println("similarity_score:", similarity_score)

}
