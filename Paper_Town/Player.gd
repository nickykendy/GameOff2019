extends KinematicBody2D

# platform move spped
const P_SPD = 200
# topdown move speed
const T_SPD = 250
# move speed when grabbing a platform
const G_SPD = 120
const JUMP_PWR = -400
const GRAV = 15
const PLATFORM = Vector2(0, -1)
const TOPDOWN = Vector2(0, 0)

var isPlatform = false
var velocity = Vector2()
var isGrabbed = false

onready var grabDetect = $GrabDetect


func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	get_input()
	if isPlatform:
		velocity = move_and_slide(velocity, PLATFORM)
	else:
		if !isGrabbed:
			move_and_slide(velocity * T_SPD, TOPDOWN)
		else:
			move_and_slide(velocity * G_SPD, TOPDOWN)

func get_input():
	var _right = Input.is_action_pressed("move_right")
	var _left = Input.is_action_pressed("move_left")
	var _up = Input.is_action_pressed("move_up")
	var _down = Input.is_action_pressed("move_down")
	
	var _jump = Input.is_action_pressed("jump")
	var _grab = Input.is_action_pressed("grab")
	var _interact = Input.is_action_just_pressed("interact")
	var _switch = Input.is_action_just_pressed("switch")
	
	
	if isPlatform:
		if _switch:
			isPlatform = false
	else:
		if _switch:
			isPlatform = true
	
	if isPlatform:
		velocity.x = (int(_right) - int(_left)) * P_SPD
		if is_on_floor() and _jump:
			velocity.y = JUMP_PWR
		else:
			velocity.y += GRAV
	else:
		velocity.x = int(_right) - int(_left)
		velocity.y = int(_down) - int(_up)
		velocity = velocity.normalized()
	
	var collider = grabDetect.get_collider()
	
	if _grab and !isGrabbed and !isPlatform:
		if collider != null and collider.has_method("grabbed"):
			collider.grabbed(true)
			isGrabbed = true

	if !_grab and isGrabbed:
		if collider != null and collider.has_method("grabbed"):
			collider.grabbed(false)
			isGrabbed = false

	if isGrabbed:
		if collider != null and collider.has_method("get_motion"):
			collider.get_motion(velocity)