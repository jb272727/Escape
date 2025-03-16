extends Piece
class_name JupiterPiece


# Called when the node enters the scene tree for the first time.
func _ready():
	value = 5
	moves = [[1,-1],[1,1], [1,0], [0,-1], [0,1], [-1,-1], [-1,0], [-1, 1]]
	model_scene = preload("res://scenes/jupiter.tscn")
	set_model_scene(model_scene)
	super._ready()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func compute_moves(current_pos):
	return super.compute_moves(current_pos)


#func compute_moves(current_pos : Array):     # current_pos is an array like (row,col) position
	#super.compute_moves(current_pos)
	#print("child computing moves for: ", self)
	#var moveset : Array = []
	#for move in moves:
		#var moved_position : Array = [null, null]
		#moved_position[0] = current_pos[0] + move[0]
		#moved_position[1] = current_pos[1] + move[1]
		#print("Moved position: ", moved_position)
		#moveset.append(moved_position)
	#return moveset
