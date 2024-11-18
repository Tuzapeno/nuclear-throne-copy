extends Node


# Clones a given node, including its properties.
#
# @param node The node to be cloned.
# @return A new node that is a duplicate of the given node, with all properties copied.
func clone_node(node: Node) -> Node:
	var cloned_node = node.duplicate()
	var properties = node.get_property_list()

	for property in properties:
		cloned_node.set(property.name, node.get(property.name))

	return cloned_node


func mean(values: Array) -> float:
	var sum = 0
	for value in values:
		sum += value
	return sum / values.size()


func clamp_vector(vector, min_value, max_value) -> Vector2:
	return Vector2(
		clamp(vector.x, min_value, max_value),
		clamp(vector.y, min_value, max_value)
	)

func get_all_nodes(parent: Node, target_type: Variant) -> Array:
	var nodes = []
	for child in parent.get_children():
		if is_instance_of(child, target_type):
			nodes.append(child)
	return nodes
