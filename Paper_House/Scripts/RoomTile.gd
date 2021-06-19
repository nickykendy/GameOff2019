extends TileMap

var state : = "t"
var tile : TileSet
var n : = 1
var frame_time : = 0.075
onready var s1 : = preload("res://Sprites/Tiles/TileSprite1.png")
onready var s2 : = preload("res://Sprites/Tiles/TileSprite2.png")
onready var s3 : = preload("res://Sprites/Tiles/TileSprite3.png")
onready var s4 : = preload("res://Sprites/Tiles/TileSprite4.png")


func _ready() -> void:
	tile = get_tileset()
	

func change(newGenre : bool) -> void:
	if state == "t":
		state = "t2p"
		$Timer.start(frame_time)
	elif state == "p":
		state = "p2t"
		$Timer.start(frame_time)


func _on_Timer_timeout() -> void:
	set_tile()


func set_tile() -> void:
	if state == "t2p":
		n += 1
		if n > 4:
			n = 4
			state = "p"
			$Timer.stop()
	elif state == "p2t":
		n -= 1
		if n < 0:
			n = 0
			state = "t"
			$Timer.stop()
	
	match n:
		1:
			tile.tile_set_texture(0, s1)
		2:
			tile.tile_set_texture(0, s2)
		3:
			tile.tile_set_texture(0, s3)
		4:
			tile.tile_set_texture(0, s4)
