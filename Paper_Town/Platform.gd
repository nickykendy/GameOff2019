extends KinematicBody2D

const G_SPD = 120

var isGrabbed = false
var velocity = Vector2()

func grabbed(result):
	isGrabbed = result

func get_motion(motion):
	velocity = motion

func _physics_process(delta):
	print(velocity)
	print(isGrabbed)
	if isGrabbed:
		move_and_slide(velocity * G_SPD)