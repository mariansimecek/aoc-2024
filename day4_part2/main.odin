package main

import "core:fmt"
import "core:os"
import "core:strings"

main :: proc() {
	bytes := #load("../input_data/day4_input.txt")

	data := string(bytes)

	line_width := strings.index_rune(data, '\n') + 1
	line_count := len(data) / line_width

	xmas_count := 0

	get_line :: proc(idx: int, line_width: int, data: ^string) -> string {
		line_start := idx * line_width
		line_end := idx * line_width + line_width - 1
		return data[line_start:line_end]
	}

	for line_idx in 0 ..< line_count {
		line := get_line(line_idx, line_width, &data)

		for char_index in 0 ..< len(line) {
			if line_idx + 3 <= line_count {

				word1: [3]u8
				word2: [3]u8

				for next_line_idx in 0 ..< 3 {
					next_line := get_line(line_idx + next_line_idx, line_width, &data)

					if char_index < line_width - 3 {
						word2[next_line_idx] = next_line[char_index + next_line_idx]
						word1[next_line_idx] = next_line[(char_index+2) - next_line_idx]
					}

				}


				if is_xmas(word1[:]) && is_xmas(word2[:]) {
					xmas_count += 1
				}

			}

		}

	}
	fmt.println("X-MAS COUNT:", xmas_count)

}


is_xmas :: proc(input: []u8) -> bool {
	res := string(input) == "MAS" || string(input) == "SAM" ? true : false

	return res
}
