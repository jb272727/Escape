extends Camera_Class


func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_left_rect_gui_input(event):
	if event.is_action_pressed("lmb"):
		switch_cam("Chess Camera")


func _on_right_rect_gui_input(event):
	if event.is_action_pressed("lmb"):
		switch_cam("Main Leaving Camera")


