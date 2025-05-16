extends Node

@export var minimax_depth : int = 4
var current_board : BoardState

@onready var arena = $"../Arena Wrapper/Arena"
var board_total_size : int
var board_buffer : int
var pos_to_move_to : Node3D
var enemy_lineup : Array
var friendly_lineup : Array
@onready var game_manager_library = %"Game Manager Library"
@onready var agent_timer = $"Agent Timer"

signal enemy_clicked_signal

# Called when the node enters the scene tree for the first time.
func _ready():
	pos_to_move_to = arena.find_child("Arena To Scale").find_child("Positions To Move To")
	await arena.arena_ready
	print("Arena Ready")
	enemy_lineup = arena.enemy_lineup
	friendly_lineup = arena.friendly_lineup
	board_total_size = arena.board_total
	board_buffer = arena.board_buffer
	current_board = BoardState.new()
	set_initial_tile_state()
	set_lineups()
	set_board()


func set_board():
	current_board.state = []
	current_board.size = board_total_size
	current_board.piece_dict.clear()
	current_board.enemy_pieces.clear()
	current_board.friendly_pieces.clear()

	for i in range(board_total_size - 1, -1, -1):
		var row = pos_to_move_to.get_child(i)
		var row_append := []
		for j in range(board_total_size - 1, -1, -1):
			var col = row.get_child(j)
			var piece = col.get_child(1)
			if piece == null:
				row_append.append(null)
			else:
				row_append.append(piece)
				current_board.piece_dict[piece] = [i - 1, j - 1]
		current_board.state.append(row_append)

	# Classify pieces as enemy or friendly based on name
	for piece in current_board.piece_dict.keys():
		if piece.name.substr(piece.name.length() - 5) == "Enemy":
			current_board.enemy_pieces.append(piece)
		else:
			current_board.friendly_pieces.append(piece)
	# @TODO: tileset changes need to be expressed here!
	

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

func do_action(action : Action) -> bool:
	current_board = action.get_resulting_state(true)
	var from = [action.from[0], action.from[1]]
	print(from)
	var to = [action.to[0], action.to[1]]
	print(to)
	arena.move_piece(from, to, action.piece, true)
	print("action completed")
	return true

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

# Run after player moves a piece, then await Game Manager click
func _on_arena_player_turn_ended():
	print("player moved piece (player turn ended)")
	game_manager_library.moved_piece = true
	set_board()
	if current_board.is_terminal():
		print("You win")
		# @TODO: emit signal to Game Manager to reset the arena and clock and other things if necessary
		return

	var action_to_do = minimax_search(current_board.copy())
	print("ACTION TO DO", action_to_do)
	action_to_do.print_action()
	
	await game_manager_library.click_signal
	# @TODO: make random timer here BETTER so the AI spends better time "thinking"
	var ran : float = 1.0 + randf()
	agent_timer.start(ran)
	await agent_timer.timeout
	do_action(action_to_do)
	if current_board.is_terminal() == true:
		print("Opponent Wins")
	
	game_manager_library.moved_piece = false
	emit_signal("enemy_clicked_signal")

