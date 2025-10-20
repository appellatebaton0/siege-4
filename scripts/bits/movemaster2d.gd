class_name MoveMasterBit2D extends Bit
## Meant for a CharacterBody, provides a basis for movement
## This is a state machine!

@onready var mover:CharacterBody2D = get_mover()
func get_mover() -> CharacterBody2D:
	
	## If SELF works, return that.
	var me = self
	if me is CharacterBody2D:
		return me
	
	## Otherwise, try the parent.
	var parent = get_parent()
	if parent is CharacterBody2D:
		return parent
	
	## If all else fails, return null.
	return null

var direction_x := -1.0 ## A float locked to -1.0, 0.0, 1.0
func set_direction_x(to:float):
	if to == 0:
		direction_x = 0
		return
	
	# Set it to -1 if negative, 1 if positive.
	direction_x = to / abs(to)
var direction_y := -1.0 ## A float locked to -1.0, 0.0, 1.0
func set_direction_y(to:float):
	if to == 0:
		direction_y = 0
		return
	
	# Set it to -1 if negative, 1 if positive.
	direction_y = to / abs(to)

func get_direction() -> Vector2:
	return Vector2(direction_x, direction_y)
func set_direction(to:Vector2):
	set_direction_x(to.x)
	set_direction_y(to.y)

@export var initial_bit:MoveBit
var current_bit:MoveBit

## All the childed bits.
var bits:Array[MoveBit] = get_move_bits()
func get_move_bits() -> Array[MoveBit]:
	var response_bits:Array[MoveBit]
	
	# Append any children that are MoveBits.
	for child in get_children():
		if child is MoveBit:
			response_bits.append(child)
	
	return response_bits

## Change the current_bit to another.
func change_bit(to:MoveBit):
	# Run the going-out function for the old bit
	if current_bit != null:
		current_bit.on_inactive()
	
	# Change to the new bit
	current_bit = to
	
	# Run the going-in function for the new bit!
	if current_bit != null:
		current_bit.on_active()

func _ready() -> void:
	# Set mover2D
	if mover == null:
		var parent = get_parent()
		if parent is CharacterBody2D:
			mover = parent
	if mover == null:
		var me = self
		if me is CharacterBody2D:
			mover = me
	
	if initial_bit == null:
		## Look in siblings
		for sibling in get_parent().get_children():
			if sibling is MoveBit:
				initial_bit = sibling
				break
	if initial_bit == null:
		## Look in children
		for child in get_children():
			if child is MoveBit:
				initial_bit = child
				break
	
	if initial_bit != null:
		change_bit(initial_bit)

func _process(delta: float) -> void:
	# Run the active bit.
	if current_bit != null:
		current_bit.active(delta)
	
	# Run all the inactive bits.
	for bit in bits:
		if bit != current_bit:
			bit.inactive(delta)

func _physics_process(delta: float) -> void:
	# Run the physically active bit.
	if current_bit != null:
		current_bit.phys_active(delta)
	
	# Run all the physically inactive bits.
	for bit in bits:
		if bit != current_bit:
			bit.phys_inactive(delta)
	
	## Run on mover
	if mover != null:
		mover.move_and_slide()
		# Pass to the bot.
		if bot.is_class("Node2D"):
			bot.global_position = mover.global_position
			mover.position = Vector2.ZERO
