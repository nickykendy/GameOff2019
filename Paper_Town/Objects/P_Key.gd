extends Area2D

func _process(delta):
	var bodies = get_overlapping_bodies()
	var isPick = false
	for body in bodies:
		if body.name == "Player" and body.has_method("pick_up"):
			isPick = body.pick_up()
	
	if isPick:
		queue_free()