extends StaticBody2D

onready var spr = $AnimatedSprite
onready var T_col = $T_CollisionShape2D
onready var P_col = $P_CollisionShape2D
onready var snd = $SoundPlayer
var isOpen = false

func open_door(newGenre):
	snd.play("OpenDoor")
	if !newGenre: # topdown
		spr.animation = "open"
		spr.frame = 0
		spr.play()
		yield(spr, "animation_finished")
		spr.stop()
		spr.animation = "OpenChange"
		spr.frame = 0
	isOpen = true

func _on_Area2D_body_entered(body):
	var player = get_tree().get_nodes_in_group("player")
	if body == player[0] and isOpen:
		print("Enter next room!")

func change(newGenre):
	if newGenre: # platform
		if isOpen:
			spr.animation = "OpenChange"
			spr.frame = 0
			spr.play("OpenChange", false)
		else:
			spr.animation = "ClosedChange"
			spr.frame = 0
			spr.play("ClosedChange", false)
		P_col.disabled = false
		T_col.disabled = true
	else: # topdown
		if isOpen:
			spr.animation = "OpenChange"
			spr.frame = 3
			spr.play("OpenChange", true)
		else:
			spr.animation = "ClosedChange"
			spr.frame = 3
			spr.play("ClosedChange", true)
		P_col.disabled = true
		T_col.disabled = false