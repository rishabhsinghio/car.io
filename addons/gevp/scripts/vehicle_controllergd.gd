extends Node3D
class_name VehicleController

@export var vehicle_node : Vehicle

# Virtual steering wheel node in your scene
@onready var virtual_steering := $"TouchInput/VirtualSteering" # change path if needed

@export_group("Input Maps", "string_")
@export var string_brake_input: String = "Brakes"
@export var string_throttle_input: String = "Throttle"
@export var string_handbrake_input: String = "Handbrake"
@export var string_clutch_input: String = "Clutch"
@export var string_toggle_transmission: String = "Toggle Transmission"
@export var string_shift_up: String = "Shift Up"
@export var string_shift_down: String = "Shift Down"

@export_group("Options")
@export var auto_throttle: bool = false
@export_range(0.0, 1.0, 0.01) var auto_throttle_value: float = 1.0


func _physics_process(_delta):
	if not vehicle_node:
		return

	# -----------------------------
	# Brake
	# -----------------------------
	if string_brake_input != "":
		vehicle_node.brake_input = Input.get_action_strength(string_brake_input)

	# -----------------------------
	# STEERING (virtual wheel only)
	# -----------------------------
	if virtual_steering:
		# get_steering() MUST return a radian float (-1,1 or real radians)
		var steer_rad: float = virtual_steering.get_steering()
		vehicle_node.steering_input = steer_rad

	# -----------------------------
	# Throttle
	# -----------------------------
	if auto_throttle:
		vehicle_node.throttle_input = auto_throttle_value
	else:
		if string_throttle_input != "":
			vehicle_node.throttle_input = pow(Input.get_action_strength(string_throttle_input), 2.0)

	# -----------------------------
	# Handbrake
	# -----------------------------
	if string_handbrake_input != "":
		vehicle_node.handbrake_input = Input.get_action_strength(string_handbrake_input)

	# -----------------------------
	# Clutch
	# -----------------------------
	if string_clutch_input != "":
		vehicle_node.clutch_input = clampf(
			Input.get_action_strength(string_clutch_input)
			+ Input.get_action_strength(string_handbrake_input),
			0.0, 1.0
		)
