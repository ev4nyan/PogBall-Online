extends KinematicBody2D

export(PackedScene) var DAGGER : PackedScene = preload("res://projectiles/wind-aa.tscn")


onready var tween = $Tween

var speed = 0
var moving = false
var destination = Vector2()
var movement = Vector2()
var puppet_movement = Vector2()
onready var attackTimer = $AATimer
#var move_direction

puppet var puppet_position = Vector2.ZERO setget puppet_position_set
puppet var puppet_velocity = Vector2()
puppet var puppet_rotation = 0

func puppet_position_set(new_value):
	puppet_position = new_value
	
	tween.interpolate_property(self, "global_position", global_position, puppet_position, 0.1)
	tween.start()


func throw_dagger(dagger_direction):
	if DAGGER:
		var dagger = DAGGER.instance()
		get_tree().current_scene.add_child(dagger)
		dagger.global_position = self.global_position
		
		var dagger_rotation = dagger_direction.angle()
		dagger.rotation = dagger_rotation
		yield(get_tree().create_timer(0.2), "timeout")
		if is_instance_valid(dagger):
			dagger.destroy()
	attackTimer.start()


func _process(delta):
	if is_network_master():
		
		look_at(get_global_mouse_position())

		if Input.is_action_pressed('click'):
			moving = true
			destination = get_global_mouse_position()
			movement = position.direction_to(destination) * speed
		
		
		if Input.is_action_pressed('aa') and attackTimer.is_stopped():
			rpc("instance_bullet", get_tree().get_network_unique_id())
			attackTimer.start()
		if not moving:
			speed = 0
		else:
			speed = 200
		
		
		
		
		
		
		
		#move_direction = rad2deg(destination.angle_to_point(position))
		if position.distance_to(destination) > 32:
			movement = move_and_slide(movement)
		else:
			moving = false
	else:
		rotation = lerp_angle(rotation, puppet_rotation, delta * 8)
		if not tween.is_active():
			move_and_slide(puppet_velocity * speed)
func _on_Network_tick_rate_timeout():
	if is_network_master():
		rset_unreliable("puppet_position", global_position)
		rset_unreliable("puppet_velocity", movement)
		rset_unreliable("puppet_rotation", rotation)


func lerp_angle(from, to, weight):
	return from + short_angle_dist(from, to) * weight

func short_angle_dist(from, to):
	var max_angle = PI * 2
	var difference = fmod(to - from, max_angle)
	return fmod(2 * difference, max_angle) - difference


sync func update_position(pos):
	global_position = pos
	puppet_position = pos

func _on_Hitbox_area_entered(area):
	if get_tree().is_network_server():
		if area.is_in_group("Ball") and area.get_parent().player_owner != int(name):
			rpc("hit_by_damager", area.get_parent().damage)
			
			area.get_parent().rpc("destroy")

sync func hit_by_damager(damage):
	if get_tree().has_network_peer():
		if get_tree().is_network_server():
			rpc("destroy")


sync func instance_bullet(id):
	var player_bullet_instance = Global.instance_node_at_location(DAGGER, Players, self.global_position)
	player_bullet_instance.name = "Bullet" + name + str(Network.networked_object_name_index)
	player_bullet_instance.set_network_master(id)
	player_bullet_instance.player_rotation = rotation
	player_bullet_instance.player_owner = id
	Network.networked_object_name_index += 1
