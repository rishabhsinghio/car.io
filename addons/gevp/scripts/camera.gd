extends Camera3D

enum CameraMode { THIRD_PERSON, FIRST_PERSON }
var current_mode = CameraMode.THIRD_PERSON

@export_group("Third Person Settings")
@export var follow_distance = 5.0
@export var follow_height = 2.0
@export var speed := 20.0

@export_group("First Person Settings")
## A Marker3D or Node3D placed exactly where the driver's head should be.
@export var cockpit_node : Node3D 

@export_group("Target")
@export var follow_this : Node3D

func _input(event):
	if event.is_action_pressed("Cam Switch"):
		if current_mode == CameraMode.THIRD_PERSON:
			current_mode = CameraMode.FIRST_PERSON
		else:
			current_mode = CameraMode.THIRD_PERSON

func _physics_process(delta: float):
	if not follow_this:
		return

	if current_mode == CameraMode.THIRD_PERSON:
		_process_third_person(delta)
	else:
		_process_first_person()

func _process_third_person(delta: float):
	var target_pos : Vector3 = follow_this.global_transform.origin
	var delta_v : Vector3 = global_position - target_pos
	
	delta_v.y = 0.0
	
	if delta_v.length() > follow_distance:
		delta_v = delta_v.normalized() * follow_distance
	
	delta_v.y = follow_height
	
	var final_pos : Vector3 = target_pos + delta_v
	# Keep the smooth lerp for third person chase logic
	global_position = global_position.lerp(final_pos, speed * delta)
	look_at(target_pos, Vector3.UP)

func _process_first_person():
	if not cockpit_node:
		return
		
	# REMOVED LERP: This locks the camera 1:1 to the seat marker
	# This eliminates the "drifting back" during acceleration.
	global_transform = cockpit_node.global_transform
