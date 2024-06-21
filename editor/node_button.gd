extends Button
class_name NodeButton

signal node_selected(id : int)
var node_name : String = "Node"
var id : int = -1

func _ready():
    text = text
    pressed.connect(_button_pressed)

func _button_pressed():
    node_selected.emit(id)