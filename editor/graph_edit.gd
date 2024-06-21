extends GraphEdit

@export var node_popup: NodePanel


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
	if node_popup != null:
		node.position = node_popup.position
	add_child(node)
