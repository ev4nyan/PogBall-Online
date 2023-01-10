extends KinematicBody2D

var ballspeed = 1
var velocity : Vector2 = Vector2.ZERO




var velocity = Vector2(1, 0)

export(int) var speed = 1400
puppet var puppet_position setget puppet_position_set
puppet var puppet_velocity = Vector2(0, 0)
onready var initial_position = global_position

var player_owner = 0

func _ready() -> void:
	
	if get_tree().has_network_peer():
		if is_network_master():
			velocity = velocity.rotated(player_rotation)
			rotation = player_rotation
			rset("puppet_velocity", velocity)
			rset("puppet_rotation", rotation)
			rset("puppet_position", global_position)
	

func _process(delta: float) -> void:
	if get_tree().has_network_peer():
		if is_network_master():
			global_position += velocity * speed * delta
		else:
			rotation = puppet_rotation
			global_position += puppet_velocity * speed * delta

func puppet_position_set(new_value) -> void:
	puppet_position = new_value
	global_position = puppet_position

sync func destroy() -> void:
	queue_free()

func _on_Destroy_timer_timeout():
	if get_tree().has_network_peer():
		if get_tree().is_network_server():
			rpc("destroy")


----










func change_speed(direction, speed, multiplier):
	velocity.x = direction.x * speed
	velocity.y = direction.y * speed
	ballspeed *= multiplier
	print(velocity)
	
func _physics_process(delta):
	var collision_object = move_and_collide(velocity * ballspeed * delta)
	if collision_object:
		velocity = velocity.bounce(collision_object.normal)

