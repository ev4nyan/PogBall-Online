extends KinematicBody2D
onready var Shaker = get_parent().get_node("Node2D").get_node("TileMap").get_node("Camera2D")
var ballspeed = 1
var velocity : Vector2 = Vector2.ZERO

func _ready():
	
	pass

func change_speed(direction, speed, multiplier):
	velocity.x = direction.x * speed
	velocity.y = direction.y * speed
	var magnitude = pow(velocity.x, 2) + pow(velocity.y, 2)
	magnitude = pow(magnitude, 0.5)
	print("magntiue is ", magnitude)
	ballspeed *= multiplier
	Shaker.shake(3,300, magnitude * 100)
	print(velocity)
	
func _physics_process(delta):
	var collision_object = move_and_collide(velocity * ballspeed * delta)
	if collision_object:
		velocity = velocity.bounce(collision_object.normal)

