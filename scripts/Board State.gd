extends Node
class_name BoardState

var enemy_pieces = []
var friendly_pieces = []
var piece_dict : Dictionary = {}
# Each element of 'state' is expected to be an Array containing Piece instances.
var state : Array = []
var tile_state : Array = []

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

# Returns an array of Actions
func get_actions_enemy() -> Array[Action]:
	var actions : Array[Action]
	for piece in enemy_pieces:
		var pos = piece_dict.get(piece)
		#print("POS! ", pos)
		var moveset = piece.enemy_compute_moves(pos)
		print(piece)
		#print("piece.enemy_compute_moves(pos):    ", piece.enemy_compute_moves(pos))
		for move in moveset:
			if not is_in_valid_area(move):
				continue
			var action = Action.new()
			var result = state[move[0]][move[1]]
			if result != null:
				if result in enemy_pieces:
					continue
				elif result in friendly_pieces:
					action.taken_piece = result
			action.from = pos
			action.to = move
			action.piece = piece
			action.previous_boardstate = self    # Includes the tile state
			actions.append(action)
	return actions

func get_actions_friendly() -> Array[Action]:
	var actions : Array[Action]
	for piece in friendly_pieces:
		var pos = piece_dict.get(piece)
		var moveset = piece.compute_moves(pos)
		for move in moveset:
			if not is_in_valid_area(move):
				continue
			var action = Action.new()
			var result = state[move[0]][move[1]]
			if result != null:
				if result in friendly_pieces:
					continue
				elif result in enemy_pieces:
					action.taken_piece = result
			action.from = pos
			action.to = move
			action.piece = piece
			action.previous_boardstate = self    # Includes the tile state
			actions.append(action)
	return actions

func is_in_valid_area(move : Array) -> bool:
	return tile_state[move[0]][move[1]]

func is_terminal() -> bool:
	if len(enemy_pieces) == 0 or len(friendly_pieces) == 0:
		return true
	return false

func utility() -> float:
	var utility = 0.0
	for piece in enemy_pieces:
		utility += piece.value
	for piece in friendly_pieces:
		utility -= piece.value
	if len(enemy_pieces) == 0:
		utility -= 50.0
	elif len(friendly_pieces) == 0:
		utility += 50.0
	return utility

func copy() -> BoardState:
	var copy = BoardState.new()
	copy.enemy_pieces = self.enemy_pieces
	copy.friendly_pieces = self.friendly_pieces
	copy.piece_dict = self.piece_dict
	copy.state = self.state
	copy.tile_state = self.tile_state
	return copy

func print_board():
	print()
	print(enemy_pieces)
	print()
	print(friendly_pieces)
	print()
	print(piece_dict)
	print()
	print(state)
	print()
	print(tile_state)
	print()
