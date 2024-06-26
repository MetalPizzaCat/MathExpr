extends GraphEdit

@export var node_popup: NodePanel

var temp_conn_node_from: BaseNode
var temp_conn_port_from: int
var temp_conn_node_to: BaseNode
var temp_conn_port_to: int


func _ready():
	if node_popup != null:
		node_popup.node_requsted.connect(create_node)


func _on_connection_request(
	from_node: StringName, from_port: int, to_node: StringName, to_port: int
):
	var start = find_child(from_node, false, false)
	var end = find_child(to_node, false, false)
	if start == null:
		printerr("Unable to find start point for connection")
		return
	if end == null:
		printerr("Unable to find end point for connection")
		return
	if end.can_connect_on_port(to_port):
		connect_node(from_node, from_port, to_node, to_port)
		end.connect_on_port(to_port, start)


func _on_popup_request(click_position: Vector2):
	if node_popup == null:
		return
	node_popup.position = click_position
	node_popup.show()


func create_node(data: NodeCreationData):
	var node: BaseNode
	if data.use_prefab and data.prefab_scene != null:
		node = data.prefab_scene.instantiate() as BaseNode
	else:
		node = data.node_script.new() as BaseNode
		node.title = data.main_name
		node.input_count = data.input_count
	node.position_offset = get_viewport().get_mouse_position()
	node.node_deleted.connect(_on_node_deleted)
	add_child(node)
	if temp_conn_node_from != null:
		_on_connection_request(temp_conn_node_from.name, temp_conn_port_from, node.name, 0)
		clear_temp_node_from()
	elif temp_conn_node_to != null:
		_on_connection_request(node.name, 0, temp_conn_node_to.name, temp_conn_port_to)
		clear_temp_node_to()


func _on_node_deleted(node_name: String):
	var conns = get_connection_list().filter(
		func(conn): return conn["to_node"] == node_name or conn["from_node"] == node_name
	)
	for connection in conns:
		disconnect_node(
			connection["from_node"],
			connection["from_port"],
			connection["to_node"],
			connection["to_port"]
		)
		if connection["from_node"] == node_name:
			var end: BaseNode = find_child(connection["to_node"], false, false)
			end.disconnect_on_port(connection["to_port"])

	var node = find_child(node_name, false, false)
	remove_child(node)
	node.queue_free()


func clear_temp_node_from():
	temp_conn_node_from = null
	temp_conn_port_from = -1


func clear_temp_node_to():
	temp_conn_node_to = null
	temp_conn_port_to = -1


func _on_connection_to_empty(from_node, from_port, release_position):
	temp_conn_node_from = find_child(from_node, false, false)
	temp_conn_port_from = from_port
	_on_popup_request(release_position)


func _on_popup_panel_popup_hide():
	clear_temp_node_from()
	clear_temp_node_to()


func _on_disconnection_request(from_node, from_port, to_node, to_port):
	disconnect_node(from_node, from_port, to_node, to_port)
	var end: BaseNode = find_child(to_node, false, false)
	end.disconnect_on_port(to_port)


func _on_connection_from_empty(to_node: StringName, to_port: int, release_position: Vector2):
	temp_conn_node_to = find_child(to_node, false, false)
	temp_conn_port_to = to_port
	_on_popup_request(release_position)
