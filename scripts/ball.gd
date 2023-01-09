extends KinematicBody2D

var ballspeed = 1
var velocity : Vector2 = Vector2.ZERO

func _ready():
	
	pass

func change_speed(direction, speed, multiplier):
	velocity.x = direction.x * speed
	velocity.y = direction.y * speed
	ballspeed *= multiplier
	print(velocity)
	
func _physics_process(delta):
	var collision_object = move_and_collide(velocity * ballspeed * delta)
	if collision_object:
		velocity = velocity.bounce(collision_object.normal)

