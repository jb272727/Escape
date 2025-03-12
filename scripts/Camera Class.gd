extends Camera3D
class_name Camera_Class

# @TODO For special transitions like to plunko machine where we might want to highlight the area we are choosing 
# (the machine itself), we can highlight inside the signal methods.  Or for objects we want to interact
# with we can use %Game_Manager_3D.get_current_object()

var self_control : Control

func _ready():
	self_control = self.get_child(0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func switch_cam(camera_name : String) -> void:
		var other_cam = self.get_parent().find_child(camera_name)
		var other_cam_control = other_cam.get_child(0)
		var control = self.get_child(0)

		control.visible = false
		other_cam.current = true
		self.current = false
		other_cam_control.visible = true
		print(%"Game Manager 3D".camera)
		%"Game Manager 3D".camera = other_cam
		print(%"Game Manager 3D".camera)

func switch_cam_library(camera_name : String) -> void:
		var other_cam = self.get_parent().find_child(camera_name)
		var other_cam_control = other_cam.get_child(0)
		var control = self.get_child(0)

		control.visible = false
		other_cam.current = true
		self.current = false
		other_cam_control.visible = true
		%"Game Manager Library".camera = other_cam

func switch_cam_library_arena_entry(camera_name : String) -> void:
		var other_cam = self.get_node("../../Arena Wrapper/Arena/Arena To Scale/Arena Cameras/").find_child(camera_name)
		var other_cam_control = other_cam.get_child(0)
		var control = self.get_child(0)

		control.visible = false
		print("this control: ", control)
		other_cam.current = true
		self.current = false
		other_cam_control.visible = true
		%"Game Manager Library".camera = other_cam

func switch_cam_library_arena_outry(camera_name : String) -> void:
	# In this method %"Game Manager Library" must be referred to
	# as the first node after the root Library bc we cannot use %
	# references when inside other scenes.
		var other_cam = self.get_node("../../../../../Cameras").find_child(camera_name)
		var other_cam_control = other_cam.get_child(0)
		var control = self.get_child(0)

		control.visible = false
		other_cam.current = true
		self.current = false
		other_cam_control.visible = true
		self.get_node("../../../../../").find_child("Game Manager Library").camera = other_cam



# @TODO re-implement the below:
#func set_cursor_type(object : CollisionObject3D):
	#if object in neighbor_scenes:
		#if object == chess_board:
			#Input.set_custom_mouse_cursor(%"Game Manager 3D".back_cursor, Input.CURSOR_ARROW)
			#return 0
	#else:
		#Input.set_custom_mouse_cursor(%"Game Manager 3D".right_cursor, Input.CURSOR_ARROW)
		#return 0
