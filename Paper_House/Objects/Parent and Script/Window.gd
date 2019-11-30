extends StaticBody2D

onready var spr = $AnimatedSprite
onready var T_col = $T_CollisionShape2D

var isOpen = true

func change(newGenre):
	if newGenre: # platform col off
		T_col.disabled = true
	else: # topdown
		if isOpen:
			T_col.disabled = false
		else:
			T_col.disabled = true

func close_window():
	spr.play("closing", false)
	isOpen = false

func open_window():
	spr.play("opening", false)
	isOpen = true

func _on_AnimatedSprite_animation_finished():
	if spr.animation == "opening":
		spr.animation = "open"
		T_col.disabled = false
	elif spr.animation == "closing":
		spr.animation = "closed"
		T_col.disabled = true
