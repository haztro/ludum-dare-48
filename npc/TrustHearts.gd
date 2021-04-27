extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func update_trust(value):
	$Sprite.visible = 0
	$Sprite2.visible = 0
	$Sprite3.visible = 0
	if value == 1:
		$Sprite2.visible = 1
		$Sprite2.position = Vector2(0, 0)
	elif value == 2:
		$Sprite.visible = 1
		$Sprite.position = Vector2(-5, 0)
		$Sprite2.visible = 1
		$Sprite2.position = Vector2(5, 0)
	elif value >= 3:
		$Sprite.visible = 1
		$Sprite.position = Vector2(-8, 2)
		$Sprite2.visible = 1
		$Sprite2.position = Vector2(0, 0)
		$Sprite3.visible = 1
		$Sprite3.position = Vector2(8, 2)
	
