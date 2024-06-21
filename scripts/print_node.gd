extends BaseNode
class_name PrintNode

func get_data() -> float:
	var val = get_value_for_input(0)
	print(val)
	return val
