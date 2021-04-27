extends StaticBody2D


export(int) var tier = 1

var ready = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if GameData.tier == tier:
		ready = 1
	


func _on_Area2D_body_entered(body):
	if body.is_in_group("player"):
		if ready:
			Hud.show_prompt("Rent for " + str(GameData.PRICES[tier-1]))
			GameData.current_door = self
		else:
			Hud.show_prompt("Locked...")
			
func _on_Area2D_body_exited(body):
	if body.is_in_group("player"):
		Hud.hide_prompt()
		GameData.current_door = null
