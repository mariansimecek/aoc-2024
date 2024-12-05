package main

import "core:fmt"
import "core:os"
import "core:slice"
import "core:strconv"
import "core:strings"
import "core:unicode"

Parser :: struct {
	curr_idx: int,
	data:     string,
}

main :: proc() {
	bytes, ok := os.read_entire_file("day3_input.txt")
	if !ok {
		fmt.println("Error reading file")
		os.exit(1)
	}

	data := string(bytes)

	parser := Parser {
		data = data,
	}

	next_char :: proc(p: ^Parser) -> (res: rune, ok: bool) {
		defer p.curr_idx += 1
		ok = p.curr_idx < len(p.data) - 1
		res = rune(p.data[p.curr_idx])
		return
	}
	next_num_chars_until :: proc(p: ^Parser, end_char: rune) -> (res: string, ok: bool) {
		idx_checkpoint := p.curr_idx
		for char in next_char(p) {
			if char == end_char {
				return p.data[idx_checkpoint:p.curr_idx - 1], true
			}
			if !unicode.is_number(char) {break}
		}
		p.curr_idx = idx_checkpoint
		return "", false
	}

	result := 0
	for char in next_char(&parser) {
		if (char == 'm') {
			nc := next_char(&parser) or_continue
			if nc == 'u' {
				nc := next_char(&parser) or_continue
				if nc == 'l' {
					nc := next_char(&parser) or_continue
					if nc == '(' {
						num1_str := next_num_chars_until(&parser, ',') or_continue
						num2_str := next_num_chars_until(&parser, ')') or_continue

						num1, _ := strconv.parse_int(num1_str)
						num2, _ := strconv.parse_int(num2_str)

						result += num1 * num2
					}
				}
			}
		}
	}

	fmt.println("Result is", result)
}
