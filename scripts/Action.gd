extends Node
class_name Action

@export var piece : Piece
@export var from : Array
@export var to : Array
@export var taken_piece : Piece = null
@export var previous_boardstate : BoardState
@export var size : int

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

# max is true if this is opponents move
func get_resulting_state(max : bool) -> BoardState:
	var resulting_state = previous_boardstate.copy()
	resulting_state.state[size-1 - from[0]-1][size-1 - from[1]-1] = null
	resulting_state.state[size-1 - to[0]-1][size-1 - to[1]-1] = piece
	if taken_piece:
		if max == true:
			resulting_state.friendly_pieces.erase(taken_piece)
		else:
			resulting_state.enemy_pieces.erase(taken_piece)
	
	return resulting_state

func print_action():
	print()
	print("Printing action -------------- !")
	print(piece)
	print("from: ", from)
	print("to: ", to)
	print("taken_piece: ", taken_piece)
	print()


