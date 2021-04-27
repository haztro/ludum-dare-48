extends Label

export(float) var tick_speed = 4

var current_num = 0
var target_num = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if abs(current_num - target_num) > 2:
		current_num += sign(target_num - current_num) * tick_speed
		text = str(current_num)

func set_number(value): 
	target_num = value
