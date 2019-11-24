extends KinematicBody2D

onready var spr = $AnimatedSprite
onready var T_col = $T_CollisionShape2D
onready var P_col = $P_CollisionShape2D

var G_SPD = 100
var isGrabbed = false
var velocity = Vector2()

func grabbed(result):
	isGrabbed = result

func set_motion(motion, spd):
	velocity = motion
	G_SPD = spd

func _physics_process(delta):
	if isGrabbed:
		move_and_slide(velocity * G_SPD)
	else:
		move_and_slide(Vector2(0, 0))

func change(newGenre):
	if newGenre: # platform
		spr.play("default", false)
		P_col.disabled = false
		T_col.disabled = true
	else: # topdown
		spr.play("default", true)
		P_col.disabled = true
		T_col.disabled = false