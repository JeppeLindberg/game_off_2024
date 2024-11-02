extends Node

var _result

# Get all children of the node that belongs to all of the given groups
func get_children_in_groups(node, groups):
	_result = []

	_get_children_in_groups_recursive(node, groups)

	return _result

func _get_children_in_groups_recursive(node, groups):
	for child in node.get_children():
		var add_to_result = true;
		for group in groups:
			if not child.is_in_group(group):
				add_to_result = false;
				break
				
		if add_to_result:
			_result.append(child)

		_get_children_in_groups_recursive(child, groups)