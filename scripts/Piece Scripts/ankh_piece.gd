extends Piece
class_name AnkhPiece



# Called when the node enters the scene tree for the first time.
func _ready():
	super._ready()
	moves = [[1, -1],[1, 1]]       # Each move in moves is an array like (drow, dcol)
	model_scene = preload("res://scenes/ankh.tscn")
	set_model_scene(model_scene)
	print("Ankh piece is ready")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func compute_moves(current_pos : Array):     # current_pos is an array like (row,col) position
	return super.compute_moves(current_pos)

