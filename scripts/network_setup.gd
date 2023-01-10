extends Node

var player = load("res://scenes/netplayer.tscn")
var ball = load("res://scenes/ball.tscn")
onready var multiplayer_config_ui = $multiplayer_config
onready var server_ip_address = $multiplayer_config/server_ip
onready var your_ip = $CanvasLayer/your_ip
onready var xTileMap = get_parent().get_node("TileMap")
func _ready():
	get_tree().connect("network_peer_connected", self, "_player_connected")
	get_tree().connect("network_peer_disconnected", self, "_player_disconnected")
	get_tree().connect("connected_to_server", self, "_connected_to_server")	
	xTileMap.hide()
	your_ip.text = "Your local IP: " + Network.ip_address
	

func _player_connected(id):
	print(id, " has connected")
	instance_player(id)
	
func _player_disconnected(id):
	print(id, " has disconnected")
	OS.alert("DC'ed!")
	if Players.has_node(str(id)):
		Players.get_node(str(id)).queue_free()

func _on_create_server_pressed():
	multiplayer_config_ui.hide()
	Network.create_server()
	xTileMap.show()
	instance_player(get_tree().get_network_unique_id())




func _connected_to_server():
	yield(get_tree().create_timer(0.1), "timeout")
	instance_player(get_tree().get_network_unique_id())
	OS.alert("INSTANCED!")

func _on_join_server_pressed():
	print("hi")
	if server_ip_address.text:
		multiplayer_config_ui.hide()
		xTileMap.show()
		Network.ip_address = server_ip_address.text
		Network.join_server()
		instance_ball()

func instance_player(id):
	var player_instance = Global.instance_node_at_location(player, Players, Vector2(rand_range(0,1280), rand_range(0,720)))
	player_instance.name = str(id)
	player_instance.set_network_master(id)
	
func instance_ball():
	var ball_instance = Global.instance_node_at_location(ball, Players, Vector2(500,0))

