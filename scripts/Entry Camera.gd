extends Camera_Class

@onready var arena = $"../../Arena Wrapper/Arena"


func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass




func _on_middle_rect_gui_input(event):
	if event.is_action_pressed("lmb"):
		arena.clear_checker_movesets()
		arena.is_picked = false
		arena.selected_coords = [null,null]
		arena.selected_piece = null
		switch_cam_library_arena_entry("Playing Camera")
		
		#change switch cam to take in a 2nd and 3rd arg
		#that is the camera we want to switch to and from
		#in order to get arena cams.
