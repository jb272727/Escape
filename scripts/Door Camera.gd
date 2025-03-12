extends Camera_Class

@onready var door_hinge = $"../../map/Shop Scene/pipes/Door Hinge"
@onready var door_animator = $"../../map/Shop Scene/pipes/Door Hinge/AnimationPlayer"
var lerped_var


func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_left_rect_gui_input(event):
	pass


func _on_right_rect_gui_input(event):
	pass


func _on_bottom_rect_gui_input(event):
	if event.is_action_pressed("lmb"):
		switch_cam("Left Side Camera")


func _on_middle_rect_gui_input(event):
	if event.is_action_pressed("lmb"):    # SWITCH TO LIBRARY SCENE
		switch_cam("Left Side Camera")


func _on_middle_rect_mouse_entered():
	door_animator.play("door open")

func _on_middle_rect_mouse_exited():
	door_animator.play_backwards("door open")
