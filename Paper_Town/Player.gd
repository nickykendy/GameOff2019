extends KinematicBody2D


const P_SPEED = 200
const T_SPEED = 250
const JUMP_POWER = -400
const GRAV = 15
const PLATFORM = Vector2(0, -1)
const TOPDOWN = Vector2(0, 0)

var is_platform = false
var velocity = Vector2()


func _ready():
	pass # Replace with function body.

func get_input():
	var _right = Input.is_action_pressed("move_right")
	var _left = Input.is_action_pressed("move_left")
	var _up = Input.is_action_pressed("move_up")
	var _down = Input.is_action_pressed("move_down")
	
	var _jump = Input.is_action_pressed("jump")
	var _grab = Input.is_action_pressed("grab")
	var _interact = Input.is_action_just_pressed("interact")
	var _switch = Input.is_action_just_pressed("switch")
	
	
	if is_platform:
		if _switch:
			is_platform = false
	else:
		if _switch:
			is_platform = true
	
	if is_platform:
		velocity.x = (int(_right) - int(_left)) * P_SPEED
		if is_on_floor() and _jump:
			velocity.y = JUMP_POWER
		else:
			velocity.y += GRAV
	else:
		velocity.x = int(_right) - int(_left)
		velocity.y = int(_down) - int(_up)
		velocity = velocity.normalized() * T_SPEED

func _physics_process(delta):
	get_input()
	if is_platform:
		velocity = move_and_slide(velocity, PLATFORM)
	else:
		move_and_slide(velocity, TOPDOWN)