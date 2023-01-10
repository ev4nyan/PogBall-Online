extends KinematicBody2D

var ballspeed = 1
var velocity : Vector2 = Vector2.ZERO

puppet var puppet_velocity = Vector2(0, 0)
puppet var puppet_position setget puppet_position_set
onready var initial_position = global_position
var player_owner = 0



func _ready():
	if get_tree().has_network_peer():
		rset("puppet_position", global_position)

func change_speed(direction, speed, multiplier):
	velocity.x = direction.x * speed
	velocity.y = direction.y * speed
	
	puppet_velocity.x = direction.x * speed
	puppet_velocity.y = direction .y * speed
	
	ballspeed *= multiplier
	
	
func _physics_process(delta):
	if get_tree().has_network_peer():
		if is_network_master():
			var collision_object = move_and_collide(velocity * ballspeed * delta)
			if collision_object:
				velocity = velocity.bounce(collision_object.normal)
		else:
			var puppet_collision = move_and_collide(puppet_velocity * ballspeed * delta)
			if puppet_collision:
				puppet_velocity = puppet_velocity.bounce(puppet_collision.normal)


func puppet_position_set(new_value) -> void:
	puppet_position = new_value
	global_position = puppet_position
	
	
