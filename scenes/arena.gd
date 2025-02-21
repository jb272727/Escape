extends Node3D

@onready var positions_to_move_to = $"Positions To Move To"

@onready var camera = $"Arena Test Camera"
var current_object : StaticBody3D
var hit_object : StaticBody3D
@onready var friendly = $Pieces/Friendly


var friendly_pieces : Array
var enemy_pieces : Array
@export var example_model_scene : PackedScene = preload("res://scenes/ankh.tscn")

# @TODO load all possible piece scripts here
const ExamplePiece = preload("res://scripts/Piece Scripts/example_piece.gd")
const AnkhPiece = preload("res://scripts/Piece Scripts/ankh_piece.gd")
const ArtifactPiece = preload("res://scripts/Piece Scripts/artifact_piece.gd")
const DiamondPiece = preload("res://scripts/Piece Scripts/diamond_piece.gd")
const JupiterPiece = preload("res://scripts/Piece Scripts/jupiter_piece.gd")
const MechanicalEyePiece = preload("res://scripts/Piece Scripts/mechanical_eye_piece.gd")
const PyramidPiece = preload("res://scripts/Piece Scripts/pyramid_piece.gd")
const SaviorPiece = preload("res://scripts/Piece Scripts/savior_piece.gd")
const ToriiPiece = preload("res://scripts/Piece Scripts/torii_piece.gd")

var board_representation : Array
var tile_representation : Array
var board_size : int = 5
var board_buffer : int = 2

var selected_piece : Node3D = null
var selected_coords : Array
var is_picked : bool = false

func _ready():
	for i in range(board_size + (board_buffer*2)): # Max board size of 7x7, board_size + board_buffer = 5 + 2 = 7
		var row := []
		for j in range(board_size + (board_buffer*2)):
			row.append(null)
		board_representation.append(row)      # row and col 0 and 1 are negative areas
		tile_representation.append(row)
	friendly_pieces.append("AnkhPiece")
	friendly_pieces.append("JupiterPiece")
	friendly_pieces.append("SaviorPiece")
	# @TODO initialize each piece to play in the game like:
	#var pawn_instance = pawn_scene.instantiate() as PawnPiece
	#add_child(pawn_instance)
	#pawn_instance.model_scene = preload("res://path/to/pawn_model.tscn")  # assign the model scene
	#pawn_instance.initialize_piece(positions_to_move_to.get_child(0).get_child(0).position)
	#pawn_instance.compute_moves(pawn_instance.current_pos)

	add_friendly_pieces()
#
	#var example_piece_instance = Node3D.new()
	#example_piece_instance.instantiate() as ExamplePiece
	#friendly.add_child(example_piece_instance)
	#example_piece_instance.initialize_piece(positions_to_move_to.get_child(0).get_child(0).global_position)
	#example_piece_instance.compute_moves(example_piece_instance.current_pos)


func _process(delta):
	var mousePos = get_viewport().get_mouse_position()
	#print(mousePos)
	var rayLength = 100
	var from = camera.project_ray_origin(mousePos)
	var to = from + camera.project_ray_normal(mousePos) * rayLength
	var space = get_world_3d().direct_space_state
	var rayQuery = PhysicsRayQueryParameters3D.new()
	rayQuery.from = from
	rayQuery.to = to
	rayQuery.collide_with_areas = true
	rayQuery.collide_with_bodies = true  # Make sure to also collide with bodies if needed

	var result = space.intersect_ray(rayQuery)
	if result:
		current_object = result.collider
	if !current_object:
		pass


func get_current_object() -> StaticBody3D:
	return current_object

func _input(event):
	if Input.is_action_just_pressed("lmb"):
		hit_object = get_current_object()
		var coords = get_coords(hit_object)
		var result = get_piece_at_coords(coords)     # result[i] is row and result[j] is column
		if result == null:
			print("Tile is not valid")
		if is_picked == false:
			selected_piece = result
			print("selected piece::: ", selected_piece)
		# Getting a new piece
			if selected_piece != null:    # User wants to move the piece on this tile
				selected_coords = coords
			is_picked = true
		else:    # Dropping a piece
			board_representation[result[0]][result[1]] = selected_piece
			board_representation[selected_coords[0]][selected_coords[1]]
			is_picked = false
		#print(selected_piece)
		#print_board()

func get_piece_at_coords(coords : Array):
	#var node_name = str(coords[0]) + "," + str(coords[1])
	print(coords)
	var node_row = positions_to_move_to.get_child(coords[0])
	var node_col = node_row.get_child(coords[1])
	#var piece : Node3D
	if len(node_col.get_children()) > 2:
		assert(len(node_col.get_children()) <= 2, "This node should never have more than two children")
	else:
		return node_col.get_child(1)    # We should always add the child as the second

func add_friendly_pieces():
	# for piece in friendly pieces: add it like the following, all scripts should already be loaded at top
	#var pyramid_instance = PyramidPiece.new()
	#friendly.add_child(pyramid_instance)
	#assert(pyramid_instance.get_script() == PyramidPiece)
	var size = 0
	for piece in friendly_pieces:
		if size < len(friendly_pieces):
			var script = map_piece(piece)
			var instance = script.new() as Node3D
			instance.name = piece
			#friendly.add_child(instance)
			#assert(instance.get_script() == script)
			var row_node = positions_to_move_to.get_child(0 + board_buffer)   # Should be row 1
			var col_node = row_node.get_child(size + board_buffer)
			col_node.add_child(instance)
			assert(instance.get_script() == script)
			
			board_representation[2][size + board_buffer] = instance
			size += 1
		else:
			print("something wrong in adding friendly loop")


# GET COORDS FOR USE IN THE SCENE TREE
func get_coords(tile : StaticBody3D):    
	var position_node = ((hit_object.get_parent()).get_parent()).get_parent()
	if position_node.visible == true:      # Do movement
		print("true")
		print(position_node.name)
		var parts = position_node.name.split(",")
		var i = int(parts[0]) + 1
		var j = int(parts[1]) + 1
		return [i, j]
	else:
		return null


func map_piece(piece_name : String):
	match piece_name:
		"AnkhPiece":
			return AnkhPiece
		"ArtifactPiece":
			return ArtifactPiece
		"DiamondPiece":
			return DiamondPiece
		"ExamplePiece":
			return ExamplePiece
		"JupiterPiece":
			return JupiterPiece
		"MechanicalEyePiece":
			return MechanicalEyePiece
		"PyramidPiece":
			return PyramidPiece
		"SaviorPiece":
			return SaviorPiece
		"ToriiPiece":
			return ToriiPiece
			
		






func add_friendly_pieces_example():
	# for piece in friendly pieces: add it like the following, all scripts should already be loaded at top
	for piece in friendly_pieces:
		var script = map_piece(piece)
		var instance = script.new()
		friendly.add_child(instance)
		assert(instance.get_script() == script)
	#var ExamplePiece = load("res://example_piece.gd")
	#var example_instance = ExamplePiece.new()
	#friendly.add_child(example_instance)
	#example_instance.set_model_scene(example_model_scene)
	#assert(example_instance.get_script() == ExamplePiece)

func print_board():
	for i in range(board_size + (board_buffer*2) - 1, -1, -1):
		print(board_representation[i])
