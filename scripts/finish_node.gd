extends BaseNode
class_name FinishNode

var input: BaseNode = null
@onready var output_label: Label = $HBoxContainer/ResultLabel

func _ready():
	generate_ui()

func connect_on_port(port: int, node: BaseNode):
	if port == 0:
		input = node


func disconnect_on_port(port: int):
	if port == 0:
		input = null


func can_connect_on_port(port: int) -> bool:
	return port == 0 and input == null


func _on_button_pressed():
	if input == null:
		printerr("%s attempted to evaluate but no input provided!" % name)
		return
	output_label.text = str(input.get_data())
