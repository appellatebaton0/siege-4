@abstract class_name Bit extends Bot
## A bot with extended functionality, that can pass that functionality 
## off to its parent if that parent is an Bot.

## Whether to use this Bit as the Bot, instead of only doing so if all else fails.
## Cuts off the hierarchy, basically.
@export var isolated := false

## The bot to pass the functionality off to.
@onready var bot:Bot = get_bot()
func get_bot() -> Bot:
	
	if isolated:
		return self
	
	var parent = get_parent()
	
	if parent is Bit:
		return parent.get_bot()
	
	if parent is Bot:
		return parent
	
	return self
