package main

import "core:fmt"
import "core:os"
import "core:slice"
import "core:strconv"
import "core:strings"

Rule :: [2]int
Print_Order :: [dynamic]int

result_sum := 0

main :: proc() {
	bytes := #load("../input_data/day5_input.txt")

	data := string(bytes)
	rules := [dynamic]Rule{}
	pages := [dynamic]Print_Order{}

	parsing_rules := true
	for line in strings.split_lines(data) {
		line := line
		if len(line) == 0 {
			parsing_rules = false
			continue
		}
		if parsing_rules {
			rule := parse_rule(line)
			append(&rules, rule)
		} else {
			page := Print_Order{}
			parse_print_order(&line, &page)
			append(&pages, page)
		}
	}

	for &page in pages {
		result := check_order(&page, &rules)
		if result {
			middle_num := page[len(page) / 2]
			result_sum += middle_num
		}
	}
	fmt.println("result:", result_sum)
}


parse_rule :: proc(line: string) -> Rule {
	res := strings.split(line, "|")

	num1, _ := strconv.parse_int(res[0])
	num2, _ := strconv.parse_int(res[1])

	return {num1, num2}
}

parse_print_order :: proc(line: ^string, print_order: ^Print_Order) {
	for char in strings.split_iterator(line, ",") {
		num, _ := strconv.parse_int(char)
		append(print_order, num)
	}
}


check_order :: proc(print_order: ^Print_Order, rules: ^[dynamic]Rule) -> bool {
	for &rule in rules {
		for i in 1 ..< (len(print_order) - 1) {
			result := check_rule(print_order[i], print_order[0:i], print_order[i + 1:], &rule)

			if !result {
				return false
			}
		}
	}
	return true
}

check_rule :: proc(current: int, prev: []int, next: []int, rule: ^Rule) -> bool {
	if rule[0] == current {
		return !slice.contains(prev, rule[1])

	} else if rule[1] == current {
		return !slice.contains(next, rule[0])
	}
	return true
}
