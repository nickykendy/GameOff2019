extends KinematicBody2D

const G_SPD = 100

var isGrabbed = false
var velocity = Vector2()

func grabbed(result):
	isGrabbed = result

func set_motion(motion):
	velocity = motion

func _physics_process(delta):
	if isGrabbed:
		move_and_slide(velocity * G_SPD)
	else:
		move_and_slide(Vector2(0, 0))