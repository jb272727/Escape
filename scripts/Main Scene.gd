extends Area

#var neighbor_scenes: Dictionary = {}
#@onready var camera = $"Main cam"
var current_object : StaticBody3D
var hit_object : StaticBody3D
@onready var chess_board = $"change scene/chess board"

func _ready():
	camera = $"Main cam"
	add_neighbor($"change scene/chess board", $"../Chess Scene")
	%"Game Manager 3D".camera = $"Main cam"

func _process(delta):
	current_object = %"Game Manager 3D".get_current_object()
	if str(%"Game Manager 3D".active_scene) == str(get_path()):
		set_cursor_type(current_object)
	# if we are in the active scene (if camera is Main cam), then display the correct arrows
	if %"Game Manager 3D".camera == camera:
		pass

func _input(event):
	if Input.is_action_just_pressed("lmb"):
		hit_object = current_object
		print(hit_object)
		if neighbor_scenes.has(hit_object): # Returns true if the dictionary contains an entry with the given key.
			move_to_scene(hit_object)
			pass

func set_cursor_type(object : CollisionObject3D):
	if object in neighbor_scenes:
		if object == chess_board:
			Input.set_custom_mouse_cursor(%"Game Manager 3D".back_cursor, Input.CURSOR_ARROW)
			return 0
	else:
		Input.set_custom_mouse_cursor(%"Game Manager 3D".right_cursor, Input.CURSOR_ARROW)
		return 0
