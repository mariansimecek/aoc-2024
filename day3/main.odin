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
	bytes := #load("../input_data/day3_input.txt")

	data := string(bytes)

	parser := Parser {
		data = data,
	}

	result := 0
	mul_enabled := true

	for {
		if next_until_sequence(&parser, "don't()") {
			mul_enabled = false
			continue
		}

		if next_until_sequence(&parser, "do()") {
			mul_enabled = true
			continue
		}

		if (mul_enabled) {
			if next_until_sequence(&parser, "mul(") {
				num1_str := next_num_chars_until(&parser, ',') or_continue
				num2_str := next_num_chars_until(&parser, ')') or_continue

				num1, _ := strconv.parse_int(num1_str)
				num2, _ := strconv.parse_int(num2_str)

				result += num1 * num2
				continue
			}
		}
		next_char(&parser) or_break
	}

	fmt.println("Result is", result)
}

next_char :: proc(p: ^Parser) -> (res: rune, ok: bool) {
	defer p.curr_idx += 1
	if p.curr_idx >= len(p.data) {
		return 0, false
	}
	char := rune(p.data[p.curr_idx])
	return char, true
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

next_until_sequence :: proc(p: ^Parser, seq: string) -> (res: bool) {
	idx_checkpoint := p.curr_idx

	for ch in seq {
		n_ch, ok := next_char(p)
		if n_ch != ch || !ok {
			p.curr_idx = idx_checkpoint
			return false
		}
	}
	return true
}
