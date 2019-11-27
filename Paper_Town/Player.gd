extends KinematicBody2D

# platform move spped
const P_SPD = 120
# topdown move speed
const T_SPD = 150
# move speed when grabbing a platform
const G_SPD = 100
const JUMP_PWR = -400
const GRAV = 15
const PLATFORM = Vector2(0, -1)
const TOPDOWN = Vector2(0, 0)
const RIGHT = 270
const UP = 180
const LEFT = 90
const DOWN = 0

var velocity = Vector2()
var isGrabbed = false
var state = "Idle"
var dir = "Right"
var isPlatform = false
var canChangeGenre = 0

onready var detect = $GrabDetect
onready var anim = $AnimatedSprite
onready var shadow = $AnimatedShadow
onready var T_col = $T_CollisionShape2D
onready var P_col = $P_CollisionShape2D
onready var InteractArea = $InteractArea
onready var hint = $Hint


func _ready():
	anim.animation = "T_IdleDown"
	var wrinkles = get_tree().get_nodes_in_group("wrinkles")
	if wrinkles != null:
		for wrinkle in wrinkles:
			wrinkle.connect("body_entered", self, "_on_WrinkleFloor_body_entered")
			wrinkle.connect("body_exited", self, "_on_WrinkleFloor_body_exited")

func _physics_process(delta):
	get_input()
	if isPlatform:
		velocity = move_and_slide(velocity, PLATFORM)
	else:
		if !isGrabbed:
			move_and_slide(velocity * T_SPD, TOPDOWN)
		else:
			velocity = move_and_slide(velocity * G_SPD, TOPDOWN)
	
	play_animation()

func get_input():
	var _right = Input.is_action_pressed("move_right")
	var _left = Input.is_action_pressed("move_left")
	var _up = Input.is_action_pressed("move_up")
	var _down = Input.is_action_pressed("move_down")
	var _interact = Input.is_action_just_pressed("interact")
	var _interacting = Input.is_action_pressed("interact")
	var _jump = Input.is_action_pressed("jump")
	var _grabbing = Input.is_action_pressed("grab")
	var _grab = Input.is_action_just_pressed("grab")
	var _switch = Input.is_action_just_pressed("switch")
	
	# change genre
	if isPlatform:
		# to topdown
		if _switch and canChangeGenre == 0:
			isPlatform = false
			P_col.disabled = true
			T_col.disabled = false
	else:
		# to platform
		if _switch and canChangeGenre == 0:
			isPlatform = true
			P_col.disabled = false
			T_col.disabled = true
	
	# change all the walls
	if _switch and canChangeGenre == 0:
		var changeables = get_tree().get_nodes_in_group("changeable")
		for _changeable in changeables:
			if _changeable.has_method("change"):
				_changeable.change(isPlatform)
	
	# jump
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
	
	# detect
	var collider = detect.get_collider()
	var world = get_parent()
	
	# grab hint
	if !isPlatform and collider != null and collider.has_method("grabbed") and !_grab and !_grabbing:
		hint.visible = true
		hint.animation = "GRAB"
	else:
		hint.visible = false
	# grab
	if !isPlatform and collider != null and collider.has_method("grabbed"):
		if _grab and _grabbing and !isGrabbed:
			collider.grabbed(true)
			isGrabbed = true
		if !_grabbing and isGrabbed:
			collider.grabbed(false)
			isGrabbed = false
	else:
		isGrabbed = false
	
	if collider != null and collider.has_method("set_motion"):
		if isGrabbed:
			collider.set_motion(velocity, G_SPD)
	else:
		isGrabbed = false
	
	# crack a pad
	if !isPlatform and collider != null and collider.is_in_group("pad"):
		hint.visible = true
		if _interacting:
			if hint.animation != "PROGRESS":
				hint.animation = "PROGRESS"
				hint.frame = 0
				hint.play()
		else:
			hint.animation = "CRACK"
	else:
		hint.visible = false
		

func play_animation():
	var head = "T_"
	
	if isPlatform:
		head = "P_"
		shadow.visible = false
		if velocity.x != 0 and velocity.y == 0 and is_on_floor():
			state = "Move"
		elif velocity.y < 0 and !is_on_floor():
			state = "Jump"
		elif velocity.y > 0 and !is_on_floor():
			state = "Fall"
		else:
			state = "Idle"
		
		if velocity.x > 0:
			dir = "Right"
		elif velocity.x < 0:
			dir = "Left"
		
		if dir == "Down" or dir == "Up":
			dir = "Right"
	else:
		head = "T_"
		shadow.visible = true
		if isGrabbed:
			state = "Grab"
		else:	
			if velocity != Vector2(0, 0):
				state = "Move"
			else:
				state = "Idle"
		
		if state != "Grab":
			if velocity.x > 0:
				dir = "Right"
				detect.rotation_degrees = RIGHT
			elif velocity.x < 0:
				dir = "Left"
				detect.rotation_degrees = LEFT
			elif velocity.y > 0:
				dir = "Down"
				detect.rotation_degrees = DOWN
			elif velocity.y < 0:
				dir = "Up"
				detect.rotation_degrees = UP
	
	var newAnim = head + state + dir
	if anim.animation != newAnim:
		anim.animation = newAnim
		anim.frame = 0
	
	if shadow.animation != state:
		shadow.animation = state
		shadow.frame = 0

func pick_up():
	var _interact = Input.is_action_just_pressed("interact")
	var isPick = false
	if isPlatform:
		if !_interact:
			hint.visible = true
			hint.animation = "PICK"
		else:
			hint.visible = false
	
	if _interact and isPlatform:
		get_door_open()
		isPick = true
	
	return isPick

func _on_WrinkleFloor_body_entered(body):
	if body.name == "Player":
		canChangeGenre += 1

func _on_WrinkleFloor_body_exited(body):
	if body.name == "Player":
		canChangeGenre -= 1


func _on_Hint_animation_finished():
	var collider = detect.get_collider()
	if collider != null and collider.is_in_group("pad"):
		collider.remove_from_group("pad")
		hint.visible = false
		get_door_open()

func get_door_open():
	var door = get_parent().get_node("T_Door")
	if door != null and door.has_method("open_door"):
		door.open_door(isPlatform)