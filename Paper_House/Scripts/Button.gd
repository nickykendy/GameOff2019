extends Area2D

onready var spr : = $AnimatedSprite
onready var T_col : = $T_CollisionShape2D
onready var snd : = $AnimationPlayer

var isPressed : = false


func change(newGenre : bool) -> void:
	# topdown
	if newGenre:
		if !isPressed:
			spr.play("default", false)
		T_col.disabled = true
	# platform
	else:
		if !isPressed:
			spr.play("default", true)
		else:
			_release()
		T_col.disabled = false


func _on_Button_body_entered(body : KinematicBody2D) -> void:
	if T_col.disabled == false and body.is_in_group("heavy") and !isPressed:
		_press()


func _on_Button_body_exited(body : KinematicBody2D) -> void:
	if T_col.disabled == false and body.is_in_group("heavy") and isPressed:
		_release()


func _on_AnimatedSprite_animation_finished() -> void:
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


func _press() -> void:
	spr.play("pressed", false)
	snd.play("click")
	isPressed = true
	
	
func _release() -> void:
	var bodies : = get_overlapping_bodies()
	print(bodies)
	if bodies.size() == 0:
		spr.play("released", false)
		snd.play("click")
		isPressed = false
