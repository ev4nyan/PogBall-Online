extends KinematicBody2D

var ballspeed = 1
var velocity : Vector2 = Vector2.ZERO
onready var tween = $Tween
puppet var puppet_velocity = Vector2(0, 0)
puppet var puppet_position setget puppet_position_set
onready var initial_position = global_position
onready var Shaker  = get_node("/root/Node2D/TileMap/Camera2D")
var player_owner = 0



func _ready():
	
	if get_tree().has_network_peer():
		rset("puppet_position", global_position)


func change_speed(direction, speed, multiplier):
	puppet_velocity.x += direction.x * speed * multiplier
	puppet_velocity.y += direction.y * speed * multiplier

	var magnitude = pow(puppet_velocity.x, 2) + pow(puppet_velocity.y, 2)
	magnitude = pow(magnitude, 0.5)
	if magnitude > 1500:
		Shaker.shake(magnitude / 1000, magnitude / 200, magnitude / 200)
	
func _process(delta):
	if get_tree().has_network_peer():
		rset("puppet_position", global_position)
#		if is_network_master():
#			var collision_object = move_and_collide(velocity * ballspeed * delta)
#			if collision_object:
#				velocity = velocity.bounce(collision_object.normal)
#		else:
		if not tween.is_active():
			var puppet_collision = move_and_collide(puppet_velocity * ballspeed * delta)
			if puppet_collision:
				puppet_velocity = puppet_velocity.bounce(puppet_collision.normal)
			#rset_unreliable("puppet_velocity", puppet_velocity)

func puppet_position_set(new_value) -> void:
	puppet_position = new_value
	tween.interpolate_property(self, "global_position", global_position, puppet_position, 0)
	tween.start()
	





func _on_hitbox_area_entered(area):
	area.get_parent().hide()
