extends Node2D


var npc = preload("res://npc/Npc.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	GameData.player = get_tree().get_nodes_in_group("player")[0]
	GameData.main = self
	
	for i in range(GameData.NUM_NPCS):
		var n = npc.instance()
		n.position.x = rand_range(-174, 282)
		n.position.y = rand_range(-280, 418)
		$World.get_node("Walls").add_child(n)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	Hud.set_rent_icon($RentTimer.time_left/$RentTimer.wait_time)
	Hud.set_food_icon($FoodTimer.time_left/$FoodTimer.wait_time)


func _on_RentTimer_timeout():
	if !GameData.pay_rent():
		GameData.game_over()


func _on_FoodTimer_timeout():
	if !GameData.pay_food():
		GameData.game_over()
