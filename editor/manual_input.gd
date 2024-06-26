extends HBoxContainer
class_name ManualInput

@export var has_input : bool = true
@export var is_input_number : bool = true
@export var text : String = ""

var spin_box : SpinBox
var check_box : CheckBox
var label : Label

var check_box_state : bool

var _editable : bool

var editable : bool = true:
	get:
		return _editable
	set(value):
		_editable = value
		if spin_box != null:
			spin_box.editable = value
		if check_box != null:
			check_box.disabled = not value
		

func _ready():
	if is_input_number:
		spin_box = SpinBox.new()
		spin_box.step = 0.1
		spin_box.allow_greater = true
		spin_box.allow_lesser = true
		add_child(spin_box)
	else:
		check_box = CheckBox.new()
		check_box.toggled.connect(_on_checkbox_toggled)
		add_child(check_box)
	
	label = Label.new()
	label.text = text
	add_child(label)
	

func _on_checkbox_toggled(state: bool):
	check_box_state = state


func get_value() -> float:
	if is_input_number:
		return spin_box.value
	return 1.0 if check_box_state else 0.0
