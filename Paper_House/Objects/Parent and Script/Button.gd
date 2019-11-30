extends Area2D

onready var spr = $AnimatedSprite
onready var T_col = $T_CollisionShape2D

var isPressed = false

func change(newGenre):
	# platform
	if newGenre:
		if !isPressed:
			spr.play("default", false)
		T_col.disabled = true
	else:
		if !isPressed:
			spr.play("default", true)
		T_col.disabled = false

func _on_Button_body_entered(body):
	if T_col.disabled == false and body.is_in_group("heavy") and !isPressed:
		spr.play("pressed", false)
		isPressed = true

func _on_Button_body_exited(body):
	if T_col.disabled == false and body.is_in_group("heavy") and isPressed:
		var bodies = get_overlapping_bodies()
		if bodies.size() == 1:
			spr.play("released", false)
			isPressed = false

func _on_AnimatedSprite_animation_finished():
	if spr.animation == "pressed":
		var windows = get_tree().get_nodes_in_group("window")
		for window in windows:
			if window.has_method("close_window"):
				window.close_window()
	elif spr.animation == "released":
		var windows = get_tree().get_nodes_in_group("window")
		for window in windows:
			if window.has_method("open_window"):
				window.open_window()