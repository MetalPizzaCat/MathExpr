extends PopupPanel
class_name NodePanel

signal node_requsted(node: NodeCreationData)
@export var nodes: Array[NodeCreationData] = []
@onready var node_list: VBoxContainer = $VBoxContainer/ScrollContainer/VBoxContainer


func _ready():
	var i = 0
	for node in nodes:
		var button = NodeButton.new()
		button.id = i
		button.text = str(node.main_name)
		button.node_selected.connect(spawn_node_from_list)
		node_list.add_child(button)
		i += 1


func spawn_node_from_list(id: int):
	if id >= 0 and id < len(nodes):
		node_requsted.emit(nodes[id])
