extends Node


const DEFAULT_PORT = 1111
const MAX_CLIENTS = 2

var server = null
var client = null

var ip_address = ""


func _ready():
	print(IP.get_local_addresses())
	#ip_address = IP.get_local_addresses()[3]
		
	for ip in IP.get_local_addresses():
		if ip.begins_with("10.") or ip.begins_with("172.16.") or ip.begins_with("192.168."):
			ip_address = ip
	#for ip in IP.get_local_addresses():
	#	if ip.begins_with("196.168."):
	#		ip_address = ip
	get_tree().connect("connected_to_server", self, "_connected_to_server")
	get_tree().connect("server_disconnected", self, "_server_disconnected")
	
func create_server():
	server = NetworkedMultiplayerENet.new()
	server.create_server(DEFAULT_PORT, MAX_CLIENTS)
	get_tree().set_network_peer(server)
	
func join_server():
	client = NetworkedMultiplayerENet.new()
	client.create_client(ip_address, DEFAULT_PORT)
	get_tree().set_network_peer(client)
	
func _connected_to_server():
	OS.alert("connected to server")
func _server_disconnected():
	OS.alert("dc'ed from serv")
