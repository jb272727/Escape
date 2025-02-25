extends Node3D

@onready var positions_to_move_to = $"Positions To Move To"

@onready var camera = $"Arena Test Camera"
var current_object : StaticBody3D
var hit_object : StaticBody3D
@onready var friendly = $Pieces/Friendly


var friendly_pieces : Array
var enemy_pieces : Array
@export var example_model_scene : PackedScene = preload("res://scenes/ankh.tscn")
@export var checker_moveset_scene : PackedScene = preload("res://scenes/checker_moveset.tscn")

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
var board_total : int = board_size + (2*board_buffer)

var selected_piece : Node3D = null
var selected_coords : Array = [null,null]
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
	friendly_pieces.append("ArtifactPiece")
	friendly_pieces.append("DiamondPiece")
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
		if coords == null:
			print("Tile is not valid")
		var result = get_piece_at_coords(coords)     # result[i] is row and result[j] is column

		print("selected piece:::!!!!! ", selected_piece)
		# Getting a new piece
		if is_picked == false:
			selected_piece = result
			if selected_piece == null:    
				return
			selected_coords = coords
			display_valid_moves(selected_piece, selected_coords)
			is_picked = true
		else:    # Dropping a piece
			# Can this piece move here?
			var moveset = selected_piece.compute_moves(selected_coords)
			if moveset != null:
				for move in moveset:
					#display_move(move)
					print("Move: ", move, " | coords clicked: ", coords)
					if coords == move:
						print("Moving " + str(selected_piece) + " to " + str(coords) + " from " + str(selected_coords))
						var moving_result = move_piece(selected_coords, coords, selected_piece)
						if moving_result == false:     # If the result matches, but we should be switching to a different piece, select that piece
							selected_coords = coords
							selected_piece = result
							display_valid_moves(selected_piece, selected_coords)
							return
						clear_checker_movesets()
						is_picked = false
						return
			# If we selected a tile which cannot be reached, un-select it 
			# | if we selected the tile of a different piece and that wasnt within the moveset, select that piece instead
			if result != null:
				selected_coords = coords
				selected_piece = result
				clear_checker_movesets()
				display_valid_moves(selected_piece, selected_coords)
				return
			else:
				clear_checker_movesets()
				is_picked = false
				selected_coords = [null,null]
				selected_piece = null

		print("printing piece")
		print_board()
		print("=-------=------------=-----------=------------=--------=-----=")

func move_piece(from : Array, to : Array, piece : Node3D):
	var from_node = positions_to_move_to.get_child(from[0] + 1).get_child(from[1] + 1).get_child(1)
	print(" From is ", from, " From node is ", from_node)
	var to_node = positions_to_move_to.get_child(to[0] + 1).get_child(to[1] + 1).get_child(1)
	var to_node_parent = positions_to_move_to.get_child(to[0] + 1).get_child(to[1] + 1)
	assert(from_node != null, "From node should never be null")
	if to_node != null:
		print("There's a piece already here! ", to)
		return false
	else:
		# Do dropping animation!!!!!!!!!!!!!
		#
		piece.reparent(to_node_parent)
		piece.global_position = to_node_parent.global_position
		return true
		
		#var global_position = child.get_global_position()
		#new_parent.add_child(child)
		#child.set_global_position(global_position)

func display_move(move : Array, pos_node : Node3D):
	var pos = pos_node.global_position
	var moveset_scene_instance = checker_moveset_scene.instantiate()
	moveset_scene_instance.global_position = pos
	
	positions_to_move_to.add_child(moveset_scene_instance, true)
	print("moveset_scene_instance global position: ", moveset_scene_instance.global_position, " ", moveset_scene_instance.position)
	

func display_valid_moves(piece : Node3D, position : Array):
	var moves = piece.compute_moves(position)
	print("Printing moves in display valid moves: ", moves)
	for move in moves:
		if !within_bounds(move):
			continue
		var pos_node = positions_to_move_to.get_child(move[0] + 1).get_child(move[1] + 1)
		if pos_node.visible == false:
			print("!!!!!! Node is not visible!!!!!!!! ", pos_node)
			continue
		if pos_node.get_child_count() <= 1:  # if > 1 there's already a piece there.
			print("Displaying move ", move, " with origin ", pos_node, " pos_node positon ", pos_node.global_position, " ", pos_node.position)
			display_move(move, pos_node)
		else:
			print("Theres already a piece at ", pos_node)

func within_bounds(move : Array) -> bool:
	if move[0] > board_size + board_buffer or move[0] < 1 - board_buffer:    # >7 or <-1
		return false
	if move[1] > board_size + board_buffer or move[1] < 1 - board_buffer:    # >7 or <-1
		return false
	return true

func clear_checker_movesets():
	print("Positions child count ", positions_to_move_to.get_child_count(), " Board total: ", board_total)
	while positions_to_move_to.get_child_count() > board_total:
		var moveset_child = positions_to_move_to.get_child(positions_to_move_to.get_child_count() - 1)
		print("removing child ", moveset_child)
		positions_to_move_to.remove_child(moveset_child)


func compute_valid_moves(piece : Node3D, position : Array):
	pass


func print_board():
	for i in range(8, -1, -1):
		var line_output : String = ""
		for j in range(0, 9):
			line_output += str(positions_to_move_to.get_child(i).get_child(j).get_child(1)) + " "
		print(line_output)

func get_piece_at_coords(coords : Array):
	#var node_name = str(coords[0]) + "," + str(coords[1])
	var node_row = positions_to_move_to.get_child(coords[0] + 1)
	var node_col = node_row.get_child(coords[1] + 1)
	#var piece : Node3D
	if len(node_col.get_children()) > 2:
		assert(len(node_col.get_children()) <= 2, "This node should never have more than two children")
	else:
		print("The piece found at coords", coords, " is ", node_col.get_child(1), " with parent ", node_col)
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
	var position_node = ((tile.get_parent()).get_parent()).get_parent()
	if position_node.visible == true:      # Do movement
		var parts = position_node.name.split(",")
		var i = int(parts[0])
		var j = int(parts[1])
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

#func print_board():
	#for i in range(board_size + (board_buffer*2) - 1, -1, -1):
		#print(board_representation[i])
