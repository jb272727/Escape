extends Camera3D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass



func _on_left_rect_gui_input(event):
	if event.is_action_pressed("lmb"):
		print("Left click detected on left")

func _on_right_rect_gui_input(event):
	if event.is_action_pressed("lmb"):
		print("Left click detected on right")
		var other_cam = self.get_parent().find_child("B Camera")
		var other_cam_control = other_cam.get_child(0)
		var self_control = self.get_child(0)
		
		self_control.visible = false
		other_cam.current = true
		self.current = false
		other_cam_control.visible = true
