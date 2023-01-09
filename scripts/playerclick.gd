extends KinematicBody2D

export(PackedScene) var DAGGER : PackedScene = preload("res://projectiles/wind-aa.tscn")
onready var attackTimer = $AATimer
var moving = false
var speed = 0
var destination = Vector2()
var movement = Vector2()
#var move_direction



func _unhandled_input(event):
	if event.is_action_pressed('click'):
		moving = true
		destination = get_global_mouse_position()
	if event.is_action_pressed('down'):
		moving = false
	if event.is_action_pressed('aa') and attackTimer.is_stopped():
		var dagger_rotation = self.global_position.direction_to(get_global_mouse_position())
		throw_dagger(dagger_rotation)
		
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
func __process(delta):
	if not moving:
		speed = 0

	else:
		speed = 250
		#speed += acceleration * delta
		#speed = min(speed, maxspeed)
	movement = position.direction_to(destination) * speed
	#move_direction = rad2deg(destination.angle_to_point(position))
	if position.distance_to(destination) > 32:
		movement = move_and_slide(movement)
	else:
		moving = false
