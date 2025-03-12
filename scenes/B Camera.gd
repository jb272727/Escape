extends Camera3D

var self_control : Control

func _ready():
	self_control = self.get_child(0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_right_rect_gui_input(event):
	pass # Replace with function body.


func _on_left_rect_gui_input(event):
	if event.is_action_pressed("lmb"):
		print("Left click detected on left")
		var other_cam = self.get_parent().find_child("A Camera")
		var other_cam_control = other_cam.get_child(0)
		
		self_control.visible = false
		other_cam.current = true
		self.current = false
		other_cam_control.visible = true
