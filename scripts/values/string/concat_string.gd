class_name ConcatString extends StringValue
## Combines given values into a custom string.

## The values to use.
@export var values:Array[Value]

## The string to return, replacing any {x} with that value in the array.
@export var string:String = "{0}"

func _ready() -> void:
	for child in get_children():
		if child is Value:
			values.append(child)

func value() -> String:
	var response:String = string
	
	for i in range(len(values)):
		if values[i] != null:
			var val = values[i].value()
			response = response.replace("{"+str(i)+"}", str(val))
	
	return response 
