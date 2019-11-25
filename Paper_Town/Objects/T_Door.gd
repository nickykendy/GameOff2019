extends StaticBody2D

onready var spr = $AnimatedSprite
onready var T_col = $T_CollisionShape2D
onready var P_col = $P_CollisionShape2D
var isOpen = false

func open_door():
	spr.animation = "default"
	spr.play("default", false)
	isOpen = true
	yield(spr, "animation_finished")
	spr.animation = "ClosedChange"

func _on_Area2D_body_entered(body):
	if body == get_parent().get_node("Player") and isOpen:
		print("Enter next room!")

func change(newGenre):
	if newGenre: # platform
		if isOpen:
			spr.play("OpenChange", false)
		else:
			spr.play("ClosedChange", false)
		P_col.disabled = false
		T_col.disabled = true
	else: # topdown
		if isOpen:
			spr.play("OpenChange", true)
		else:
			spr.play("ClosedChange", true)
		P_col.disabled = true
		T_col.disabled = false