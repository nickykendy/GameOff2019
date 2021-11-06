extends KinematicBody2D
class_name Platform

onready var spr : = $AnimatedSprite
onready var T_col : = $T_CollisionShape2D
onready var P_col : = $P_CollisionShape2D
onready var rem : = $RemoteTransform2D

var isGrabbed : = false


func grabbed(result : bool) -> void:
	isGrabbed = result


func push_and_pull(velocity: Vector2) -> void:
	move_and_slide(velocity, Vector2())


func change(newGenre : bool) -> void:
	if newGenre: # platform
		spr.play("default", false)
		P_col.set_deferred("disabled", false)
		T_col.set_deferred("disabled", true)
#		P_col.disabled = false
#		T_col.disabled = true
	else: # topdown
		spr.play("default", true)
		P_col.set_deferred("disabled", true)
		T_col.set_deferred("disabled", false)
#		P_col.disabled = true
#		T_col.disabled = false
