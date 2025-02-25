extends Node3D
class_name Piece

var current_pos
var moveset_pattern # The graphic
var positions_to_move_node : Node3D
var model_instance : Node3D
var moves : Array   # Each move in moves is an array like (drow, dcol)

@export var model_scene : PackedScene


# Called when the node enters the scene tree for the first time.
func _ready():
	positions_to_move_node = get_parent().get_parent().get_parent().get_child(0)
	print(positions_to_move_node)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func initialize_piece(position):
	current_pos = position
	print("Initialized piece at: ", current_pos)

func compute_moves(current_pos):
	print("Computing moves for node: ", self)
	var moveset : Array = []
	for move in moves:
		var moved_position : Array = [null, null]
		moved_position[0] = current_pos[0] + move[0]
		moved_position[1] = current_pos[1] + move[1]
		#print("Computed Move: ", moved_position)
		moveset.append(moved_position)
	return moveset

func set_model_scene(scene : PackedScene):
	model_scene = scene
	model_instance = model_scene.instantiate() as Node3D
	add_child(model_instance)
	print("Model instance added to piece.")
