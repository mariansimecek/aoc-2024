package main

import "core:fmt"
import "core:os"
import "core:slice"
import "core:strconv"
import "core:strings"

Rule :: [2]int
Print_Order :: [dynamic]int

result_sum := 0
fixed_result_sum := 0

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
		} else {
			fix_order(&page, &rules)
			fixed_result := check_order(&page, &rules)
			assert(fixed_result)

			middle_num := page[len(page) / 2]
			fixed_result_sum += middle_num
		}
	}

	fmt.println("part1 result:", result_sum)
	fmt.println("part2 result:", fixed_result_sum)
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
	for &rule, rule_idx in rules {
		result, _ := check_rule(print_order[:], &rule)

		if !result {
			return false
		}
	}
	return true
}

check_rule :: proc(print_order: []int, rule: ^Rule) -> (is_valid: bool = true, indexes: [2]int) {
	index_prev, found_prev := slice.linear_search(print_order, rule[0])
	index_next, found_next := slice.linear_search(print_order, rule[1])

	indexes = {index_next, index_prev}

	if found_prev && found_next {
		is_valid = index_prev < index_next
		return
	}

	return
}


//NOTE: bruteforce the result, there is better solution
fix_order :: proc(print_order: ^Print_Order, rules: ^[dynamic]Rule) {
	is_valid := false
	for !is_valid {
		for &rule, rule_idx in rules {
			res, indexes := check_rule(print_order[:], &rule)
			if res {
				is_valid = true
				continue
			} else {
				is_valid = false
				temp := print_order[indexes[0]]
				print_order[indexes[0]] = print_order[indexes[1]]
				print_order[indexes[1]] = temp
				break
			}
		}
	}
}
