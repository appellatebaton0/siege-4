@abstract class_name DamageBit2D extends AreaBit2D
## Runs its damage function once applied, and can be applied
## by signal or when its area collides with something.

## Whether to damage something when this Damage's area collides with it.
@export var applies_on_contact := true

## Whether this instance is on something that needs to be damaged
var applied := false

## The HealthBits of the bot this damage is applied to.
var health:Array[HealthBit]

## Run when a body / area enters the Master
func on_body_entered(body:Node) -> void:
	if applies_on_contact and body is Bot:
		apply(body) # If can and should, apply on contact.
func on_area_entered(area:Node) -> void:
	if applies_on_contact and area is Bot:
		apply(area) # If can and should, apply on contact.

## Applies this damage to a bot.
func apply(to:Bot = bot):
	
	print("applied ", self, " to ", to)
	
	# Duplicate this damage
	var new = duplicate()
	
	# Reparent it to [to].
	if new.get_parent() != null:
		new.reparent(to)
	else:
		to.add_child(new)
	
	# Tell it it's an active damager, and update its bot.
	new.applied = true
	new.bot = new.get_bot()

func _process(_delta: float) -> void:
	if applied:
		
		# If haven't yet, load the HealthBits of the current bot into [health]
		if health == null:
			for bit in scan_bot("HealthBit", false):
				if bit is HealthBit:
					health.append(bit)
		
		# Apply this DamageBit's damage.
		damage()

@abstract func damage() -> void
## Should be run by the DamageBit when it's DONE damaging.
func end() -> void:
	queue_free()
