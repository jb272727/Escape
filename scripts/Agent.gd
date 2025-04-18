extends Node

@export var minimax_depth : int = 4
var current_board : BoardState

@onready var arena = $"../Arena Wrapper/Arena"
var board_total_size : int
var board_buffer : int
var pos_to_move_to : Node3D
var enemy_lineup : Array
var friendly_lineup : Array

# Called when the node enters the scene tree for the first time.
func _ready():
	pos_to_move_to = arena.find_child("Arena To Scale").find_child("Positions To Move To")
	await arena.arena_ready
	print("-----------------YEah---------------")
	enemy_lineup = arena.enemy_lineup
	friendly_lineup = arena.friendly_lineup
	board_total_size = arena.board_total
	board_buffer = arena.board_buffer
	current_board = BoardState.new()
	set_initial_tile_state()
	set_lineups()
	set_board()

func set_board():
	print("SETTING BOARD SETTING BOARD SETTING BOARD SETTING BOARD")
	current_board.state = []
	for i in range(board_total_size - 1, -1, -1):
		var row = pos_to_move_to.get_child(i)
		var row_append := []
		for j in range(board_total_size - 1, -1, -1):
			var col = row.get_child(j)
			var piece = col.get_child(1)
			if piece == null:
				row_append.append(null)
				#current_board.state[i][j] = null
			else:
				row_append.append(piece)
				#current_board.state[i][j] = piece
				current_board.piece_dict[piece] = [i,j]
		current_board.state.append(row_append)
		print("current state rep:")
		print(current_board.state)

func set_initial_tile_state():
	for i in range(board_total_size):
		var row_append := []
		for j in range(board_total_size):
			if i < board_buffer or i > board_total_size - (2*board_buffer) + 1 or j < board_buffer or j > board_total_size - (2*board_buffer) + 1:
				row_append.append(false)
			else:
				row_append.append(true)
		current_board.tile_state.append(row_append)
				#current_board.tile_state[i][j] = false
			#else:
				#current_board.tile_state[i][j] = true

func set_lineups():
	current_board.enemy_pieces = enemy_lineup
	current_board.friendly_pieces = friendly_lineup

func do_action(action : Action):
	current_board = action.get_resulting_state(true)
	var from = [action.from[0] - 1, action.from[1] - 1]
	var to = [action.to[0] - 1, action.to[1] - 1]
	arena.move_piece(from, to, action.piece)

# @TODO just check if the node is visible: if yes -> true, if no -> false
#func set_tile_state()

# Max will be the AI opponent, min is player
func minimax_search(state : BoardState) -> Action:
	var move = max_value(state, 0)
	return move[1]

func max_value(state : BoardState, depth : int) -> Array: #returns a <utility, action> pair
	if state.is_terminal() or depth == minimax_depth: 
		return [state.utility(), null]
	
	var move = [-INF, null]
	for action in state.get_actions_enemy():
		var values = min_value(action.get_resulting_state(true), depth + 1)
		if values[0] > move[0]:
			move = [values[0], action]
	return move

func min_value(state : BoardState, depth : int) -> Array:
	if state.is_terminal() or depth == minimax_depth:
		return [state.utility(), null]
	
	var move = [INF, null]
	for action in state.get_actions_friendly():
		var values = max_value(action.get_resulting_state(false), depth + 1)
		if values[0] < move[0]:
			move = [values[0], action]
	return move


func _on_arena_player_turn_ended():
	set_board()
	current_board.print_board()
	var action_to_do = minimax_search(current_board)
	print("ACTION TO DO", action_to_do)
	action_to_do.print_action()
	current_board.print_board()
	do_action(action_to_do)
