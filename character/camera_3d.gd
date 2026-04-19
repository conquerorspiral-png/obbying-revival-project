extends Camera3D

@export var target: Player
@export var distance := 10.0
@export var max_distance := 20.0
@export var zoom_speed := .4
@export var smooth_speed := 5

var yaw := 0.0
var pitch := 0.0
var rotating := false
	
enum CameraMode {NORMAL, FIRSTPERSON}
@export var shiftlocked:bool = false
@export var mode: CameraMode = CameraMode.NORMAL

var target_distance := 10.0 :
	set(new):
		if new <= 0:
			mode = CameraMode.FIRSTPERSON
		target_distance = new

func _ready():
	target_distance = distance

func _input(event):
	if Input.is_action_just_pressed("shift_lock"):
		shiftlocked = !shiftlocked
	if not shiftlocked:
		rotating = Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT)
		Input.set_mouse_mode(
			Input.MOUSE_MODE_CAPTURED if rotating else Input.MOUSE_MODE_VISIBLE
		)
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_WHEEL_UP):
		target_distance -= zoom_speed
	elif Input.is_mouse_button_pressed(MOUSE_BUTTON_WHEEL_DOWN):
		target_distance += zoom_speed

	target_distance = clamp(target_distance, 0, max_distance)
	mode = CameraMode.NORMAL if target_distance > 0 else CameraMode.FIRSTPERSON

	if not shiftlocked and mode == CameraMode.NORMAL:
		rotating = Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT)
		Input.set_mouse_mode(
			Input.MOUSE_MODE_CAPTURED if rotating else Input.MOUSE_MODE_VISIBLE
		)

		target_distance = clamp(target_distance, 0, max_distance)
	else:
		rotating = true
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	target.visible = mode == CameraMode.NORMAL
	target.shiftlockLogo.visible = shiftlocked
	target.follow_camera = shiftlocked or mode == CameraMode.FIRSTPERSON

	if event is InputEventMouseMotion:
		if rotating or shiftlocked:
			yaw -= event.relative.x * target.sensitivity
			pitch -= event.relative.y * target.sensitivity
			pitch = clamp(pitch, -1.5, 1.5)

func _process(delta):
	if target == null:
		return
	
	distance = lerp(distance, target_distance, smooth_speed * delta)
	rotation = Vector3(pitch,yaw,0)
	var desired_pos = target.get_node("Focus").global_position + global_basis.z*distance
	
	global_position = desired_pos
