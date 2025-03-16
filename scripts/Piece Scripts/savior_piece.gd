extends Piece
class_name SaviorPiece


# Called when the node enters the scene tree for the first time.
func _ready():
	value = 10
	model_scene = preload("res://scenes/savior.tscn")
	moves = [[1,0],[0,-1],[0,1],[-1,0]]
	set_model_scene(model_scene)
	super._ready()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func compute_moves(current_pos):
	return super.compute_moves(current_pos)
	print("child computing moves for: ", self)
