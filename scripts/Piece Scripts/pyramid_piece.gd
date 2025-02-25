extends Piece
class_name PyramidPiece


# Called when the node enters the scene tree for the first time.
func _ready():
	super._ready()
	model_scene = preload("res://scenes/pyramid.tscn")
	set_model_scene(model_scene)
	print("Pyramid piece is ready")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func compute_moves(current_pos):
	return super.compute_moves(current_pos)
	print("child computing moves for: ", self)
