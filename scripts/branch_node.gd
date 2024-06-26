extends BaseNode

class_name BranchNode


func get_data() -> float:
	return get_value_for_input(1) if get_value_for_input(0) == 0.0 else get_value_for_input(2)
