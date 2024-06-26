extends BaseNode

class_name LoopSumNode


func get_data() -> float:
	var start: int = int(get_value_for_input(0))
	var end: int = int(get_value_for_input(1))

	var sum: float = 0.0
	print(end)
	for i in range(start, end):
		sum += get_value_for_input(2)
	return sum
