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
const PLATFORM_GENRE = true
const TOPDOWN_GENRE = false

var velocity = Vector2()
var isGrabbed = false
var state = "Idle"
var dir = "Right"
var isPlatform = false setget change_genre
var canChangeGenre = 0
var canChange = true
var canPlaySound = true

onready var detect = $GrabDetect
onready var anim = $PlayerAnimation
onready var shadow = $AnimatedShadow
onready var T_col = $T_CollisionShape2D
onready var P_col = $P_CollisionShape2D
onready var hint = $Hint
onready var sound = $SoundAnim
onready var snd_footstep = $AudioFootstep
onready var snd_change = $AudioChangeGenre
onready var cd = $Timer


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

func change_genre(value):
	canChange = false
	play_snd("ChangeGenre")
	canPlaySound = false
	isPlatform = value
	cd.start(0.2)

func play_snd(snd):
	sound.play(snd)
	canPlaySound = false
	
func get_input():
	var _right = Input.is_action_pressed("move_right")
	var _left = Input.is_action_pressed("move_left")
	var _up = Input.is_action_pressed("move_up")
	var _down = Input.is_action_pressed("move_down")
	var _interact = Input.is_action_just_pressed("interact")
	var _interacting = Input.is_action_pressed("interact")
	var _jump = Input.is_action_pressed("jump")
	var _switch = Input.is_action_just_pressed("switch")
	
	# change genre
	if isPlatform:
		# to topdown
		if _switch and canChangeGenre == 0 and canChange:
			change_genre(TOPDOWN_GENRE)
			detect.collide_with_areas = false
			P_col.disabled = true
			T_col.disabled = false
			
	else:
		# to platform
		if _switch and canChangeGenre == 0 and canChange:
			change_genre(PLATFORM_GENRE)
			detect.collide_with_areas = true
			P_col.disabled = false
			T_col.disabled = true
	
	# play sound
	print(!_switch,state,canPlaySound)
	if !_switch and state == "Move" and canPlaySound:
		
		play_snd("Footstep")
		
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
	
	# grab hint
	if !isPlatform and collider != null and collider.is_in_group("platform") and !_interact and !_interacting:
		hint.visible = true
		hint.animation = "GRAB"
	# crack a pad
	elif isPlatform and collider != null and collider.is_in_group("pad"):
		hint.visible = true
		if _interacting:
			if hint.animation != "PROGRESS":
				hint.animation = "PROGRESS"
				hint.frame = 0
				hint.play()
		else:
			hint.stop()
			hint.animation = "CRACK"
	elif !isPlatform and collider != null and collider.is_in_group("key"):
		if _interact and collider.has_method("is_picked"):
			collider.is_picked()
			get_door_open()
			hint.visible = false
		else:
			hint.visible = true
			hint.animation = "PICK"
	else:
		hint.visible = false
	# grab
	if !isPlatform and collider != null and collider.has_method("grabbed"):
		if _interact and _interacting and !isGrabbed:
			collider.grabbed(true)
			isGrabbed = true
		if !_interacting and isGrabbed:
			collider.grabbed(false)
			isGrabbed = false
	else:
		isGrabbed = false
	
	if collider != null and collider.has_method("set_motion"):
		if isGrabbed:
			collider.set_motion(velocity, G_SPD)
	else:
		isGrabbed = false
	

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
			detect.rotation_degrees = RIGHT
		elif velocity.x < 0:
			dir = "Left"
			detect.rotation_degrees = LEFT
		
		if dir == "Down" or dir == "Up":
			dir = "Right"
			detect.rotation_degrees = RIGHT
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
	
	if anim.animation == "P_FallRight" and newAnim == "P_IdleRight" and canPlaySound:
		play_snd("Fall")
		
	if anim.animation != newAnim:
		anim.animation = newAnim
		anim.frame = 0
	
	if shadow.animation != state:
		shadow.animation = state
		shadow.frame = 0
	
	if state == "Grab" and velocity != Vector2(0, 0):
		play_snd("GrabMove")

func _on_WrinkleFloor_body_entered(body):
	if body.name == "Player":
		canChangeGenre += 1

func _on_WrinkleFloor_body_exited(body):
	if body.name == "Player":
		canChangeGenre -= 1

func _on_Hint_animation_finished():
	var collider = detect.get_collider()
	if hint.animation == "PROGRESS":
		if collider != null and collider.is_in_group("pad") and collider.has_method("is_cracking"):
			collider.is_cracking()
			collider.remove_from_group("pad")
			hint.visible = false
			get_door_open()

func get_door_open():
	var doors = get_tree().get_nodes_in_group("door")
	if doors != null:
		for door in doors:
			if door.has_method("open_door"):
				door.open_door(isPlatform)

func _on_Timer_timeout():
	canChange = true

func _on_SoundAnim_animation_finished(anim_name):
	canPlaySound = true

func _on_PlayerAnimation_frame_changed():
	pass # Replace with function body.
