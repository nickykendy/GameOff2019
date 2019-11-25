extends Area2D

func pick_up(isPlatform):
	var bodies = get_overlapping_bodies()
	for body in bodies:
		print(body.name)
		if body.name == "Player":
			if isPlatform:
				var door = get_parent().get_node("T_Door")
				if door.has_method("open_door"):
					door.open_door()
					queue_free()