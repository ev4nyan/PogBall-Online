extends KinematicBody2D

export(PackedScene) var DAGGER : PackedScene = preload("res://projectiles/wind-aa.tscn")
#onready var attackTimer = $AATimer
onready var tween = $Tween


var moving = false
var destination = Vector2()
var movement = Vector2()
#var move_direction

puppet var puppet_position = Vector2.ZERO setget puppet_position_set
puppet var puppet_velocity = Vector2()
#puppet var puppet_rotation = 0

func puppet_position_set(new_value):
	puppet_position = new_value
	
	tween.interpolate_property(self, "global_position", global_position, puppet_position, 0.1)
	tween.start()

func _process(delta):
	if is_network_master():
		if Input.is_action_pressed('click'):
			destination = get_global_mouse_position()
			movement = position.direction_to(destination) * 250
		#move_direction = rad2deg(destination.angle_to_point(position))
			if position.distance_to(destination) > 32:
				movement = move_and_slide(movement)
	else:
#		rotation_degrees = lerp(rotation_degrees, puppet_rotation, delta * 8)
		if not tween.is_active():
			move_and_slide(puppet_velocity * 250)
func _on_Network_tick_rate_timeout():
	if is_network_master():
		rset_unreliable("puppet_position", global_position)
		rset_unreliable("puppet_velocity", movement)
