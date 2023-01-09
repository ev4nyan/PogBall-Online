extends Area2D
var red_tex = preload("res://assets/ba2red.png")

export(int) var SPEED : int = 500
var direction : Vector2



func _physics_process(delta):
	direction = Vector2.RIGHT.rotated(rotation)
	global_position += SPEED * direction * delta

func destroy():
	queue_free()
	


func _on_windaa_area_entered(area):
	destroy()


func _on_windaa_body_entered(body):
	print(direction, "body")
	if body.has_method("change_speed"):
		body.change_speed(direction, SPEED, 1.05)
		print(body.set_collision_layer(64))
		body.get_node("Sprite").set_texture(red_tex)
	destroy()
