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
