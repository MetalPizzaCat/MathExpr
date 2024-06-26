extends GraphNode
class_name BaseNode

signal node_deleted(name : String)

@export var input_count: int = 1
var inputs: Array[BaseNode] = []
var manual_inputs: Array[SpinBox] = []

func generate_ui():
	var close_button = Button.new()
	close_button.text = "x"
	close_button.flat = true
	close_button.pressed.connect(_on_delete_request)
	get_titlebar_hbox().add_child(close_button)


func _ready():
	for i in range(0, input_count):
		var spin_box = SpinBox.new()
		spin_box.step = 0.1
		spin_box.allow_greater = true
		spin_box.allow_lesser = true
		add_child(spin_box)
		manual_inputs.append(spin_box)
		set_slot(i, true, 0, Color.GREEN, i == 0, 0, Color.GREEN)
	inputs.resize(input_count)
	generate_ui()


func can_connect_on_port(port: int) -> bool:
	if port < 0 or port >= len(inputs):
		return false
	return inputs[port] == null


func connect_on_port(port: int, node: BaseNode):
	inputs[port] = node
	manual_inputs[port].editable = false


func disconnect_on_port(port: int):
	inputs[port] = null
	manual_inputs[port].editable = true


func get_value_for_input(port: int) -> float:
	return manual_inputs[port].value if inputs[port] == null else inputs[port].get_data()


func get_data() -> float:
	printerr("No operation defined")
	return 0.0


func _on_delete_request():
	node_deleted.emit(name)
