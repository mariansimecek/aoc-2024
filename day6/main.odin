package main

import "core:fmt"
import "core:os"
import "core:slice"
import "core:strconv"
import "core:strings"


Pos :: [2]i32

Player :: struct {
	pos:       Pos,
	direction: Direction,
	visited:   [dynamic]Pos,
}

Direction :: enum {
	Top,
	Right,
	Bottom,
	Left,
}

main :: proc() {
	bytes := #load("../input_data/day6_input.txt")

	data := string(bytes)

	obstacles: [dynamic]Pos = {}
	player := Player {
		direction = .Top,
	}


	line_idx := 0
	width: i32 = 0

	for line in strings.split_lines_iterator(&data) {
		defer line_idx += 1

		if width == 0 {
			width = i32(len(line))
		}

		for char, char_idx in line {
			switch char {
			case '#':
				append(&obstacles, Pos{i32(char_idx), i32(line_idx)})
			case '^':
				player.pos = Pos{i32(char_idx), i32(line_idx)}
				append(&player.visited, player.pos)
			}
		}
	}

	for next_step(&player, obstacles[:], width, i32(line_idx)) {
	}


	fmt.println("steps:", len(player.visited))
}

next_step :: proc(player: ^Player, obstacles: []Pos, width: i32, height: i32) -> bool {
	prev_pos := player.pos

	switch player.direction {
	case .Top:
		player.pos.y -= 1
	case .Bottom:
		player.pos.y += 1
	case .Left:
		player.pos.x -= 1
	case .Right:
		player.pos.x += 1
	}

	if player.pos.x < 0 ||
	   player.pos.y < 0 ||
	   player.pos.x > (width - 1) ||
	   player.pos.y > (height - 1) {
		return false
	}

	for obstacle in obstacles {
		if player.pos == obstacle {
			player.direction = turn_90deg(player.direction)
			player.pos = prev_pos

			return true
		}
	}

	if !slice.contains(player.visited[:], player.pos) {
		append(&player.visited, player.pos)
	}
	return true
}

turn_90deg :: proc(direction: Direction) -> Direction {
	dir := direction
	switch direction {
	case .Top:
		dir = .Right
	case .Bottom:
		dir = .Left
	case .Left:
		dir = .Top
	case .Right:
		dir = .Bottom
	}

	return dir
}
