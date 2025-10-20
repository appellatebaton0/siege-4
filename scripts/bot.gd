class_name Bot extends Node
## A node that has completely modular functionality :D

@warning_ignore("unused_signal") signal freeing
func bot_free():
	freeing.emit()
	call_deferred("queue_free")

func bot_free_val(_x):
	bot_free()
