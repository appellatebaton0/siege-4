class_name HealthBit extends Bit
## Provides all the functionality expected of a Bot that would have health.
## Signals on taking damage and health reaching zero, etc.

signal took_damage ## Emitted when the health value decreases.
signal took_regeneration ## Emitted when the health value increases.
signal reached_zero ## Emitted when the health value reaches zero.

@export var max_health := 40.0
@export var health := 40.0

## Called by things that want to do damage, namely DamageBits.
func modify_health(amount:float):
	if amount == 0:
		return
	elif amount < 0: ## If the modification is damage, take the damage
		health = max(0, health + amount)
		took_damage.emit()
	else: ## If the modification is regen, regenerate the health.
		health = min(max_health, health + amount)
		took_regeneration.emit()
	
	if health <= 0:
		reached_zero.emit()
