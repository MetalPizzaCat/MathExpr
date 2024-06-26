extends BaseNode


func get_data() -> float:
	var result: float = 0.0
	for i in range(0, len(inputs)):
		result += get_value_for_input(i)
	return result
