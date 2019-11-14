extends KinematicBody2D

var is_platform = false
var top_down_spd = 100
var platform_spd = 200
var jump_height = 1000
var gravity = 200
var is_in_air = false


func _ready():
	pass # Replace with function body.

func get_input():
	var _right = Input.is_action_pressed("move_right")
	var _left = Input.is_action_pressed("move_left")
	var _up = Input.is_action_pressed("move_up")
	var _down = Input.is_action_pressed("move_down")
	var _jump = Input.is_action_just_pressed("jump")
	var _grab = Input.is_action_pressed("grab")
	var _interact = Input.is_action_just_pressed("interact")
	var _switch = Input.is_action_just_pressed("switch")
	
	var input_vec = Vector2()
	
	if is_platform:
		if _switch:
			is_platform = false
	else:
		if _switch:
			is_platform = true
	
	if is_platform:
		if _right:
			input_vec.x += 1
		if _left:
			input_vec.x -= 1
		if _jump and is_on_floor():
			input_vec.y -= 1
		if !is_on_floor():
			input_vec.y += 1
	else:
		if _right:
			input_vec.x += 1
		if _left:
			input_vec.x -= 1
		if _up:
			input_vec.y -= 1
		if _down:
			input_vec.y += 1
	
	return input_vec.normalized()

func _physics_process(delta):
	var motion = get_input()
	if is_platform:
		move_and_slide(motion * platform_spd, Vector2(0, 1))
	else:
		move_and_slide(motion * top_down_spd, Vector2(0, 0))