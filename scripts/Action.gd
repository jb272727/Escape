extends Node
class_name Action

@export var piece : Piece
@export var from : Array
@export var to : Array
@export var taken_piece : Piece = null
@export var previous_boardstate : BoardState

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

# max is true if this is opponents move
func get_resulting_state(max : bool) -> BoardState:
	var resulting_state = previous_boardstate.copy()
	resulting_state.state[from[0]][from[1]] = null
	resulting_state.state[to[0]][to[1]] = piece
	if taken_piece:
		print("TAKEN PIECE: ", taken_piece)
		if max == true:
			resulting_state.friendly_pieces.erase(taken_piece)
		else:
			resulting_state.enemy_pieces.erase(taken_piece)
	
	return resulting_state

func print_action():
	print()
	print(piece)
	print()
	print("from: ", from)
	print()
	print("to: ", to)
	print()
	print("taken_piece: ", taken_piece)


