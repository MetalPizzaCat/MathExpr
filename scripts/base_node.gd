extends GraphNode
class_name BaseNode

signal node_deleted(name: String)

@export var input_data : Array[InputData] = []
var inputs: Array[BaseNode] = []
var manual_inputs: Array[ManualInput] = []


func generate_ui():
	var close_button = Button.new()
	close_button.text = "x"
	close_button.flat = true
	close_button.pressed.connect(_on_delete_request)
	get_titlebar_hbox().add_child(close_button)


func _ready():
	var ind = 0
	for data in input_data:
		var input = ManualInput.new()
		input.text = data.text
		input.is_input_number = data.is_number
		manual_inputs.append(input)
		add_child(input)
		set_slot(ind, true, 0, Color.GREEN if data.is_number else Color.RED, ind == 0, 0, Color.GREEN)
		ind += 1
	inputs.resize(len(input_data))
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
	return manual_inputs[port].get_value() if inputs[port] == null else inputs[port].get_data()


func get_data() -> float:
	printerr("No operation defined")
	return 0.0


func _on_delete_request():
	node_deleted.emit(name)
