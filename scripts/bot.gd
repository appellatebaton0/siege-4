class_name Bot extends Node
## A node that has completely modular functionality :D

@warning_ignore("unused_signal") signal freeing
func bot_free():
	freeing.emit()
	call_deferred("queue_free")

func bot_free_val(_x):
	bot_free()

## Get a bit in the children, using its class_name.
func get_sub_bit(bit_id:String, include_self := false, depth := 4, with:Node = self) -> Bit:
	
	if depth <= 0:
		return null
	
	# If can return self and self works, do that.
	if include_self and get_script().get_global_name() == bit_id:
		return self
	
	# Otherwise, look in the children recursively
	for child in with.get_children():
		# Try this child, first.
		if child is Bit:
			# If its class_name matches, return it.
			if child.get_script().get_global_name() == bit_id and child.bot == self:
				return child
		
		# Else, run this function for each Bit child, with one less recursion so it's not infinite.
		var attempt = get_sub_bit(bit_id, true, depth - 1, child)
		
		# If anything is found, return that.
		if attempt != null:
			return attempt
	
	return null	
