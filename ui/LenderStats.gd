extends MarginContainer



var lender = null
var amount = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var direction = -(GameData.player.position - lender.position).normalized()
	var angle = direction.angle()
	$Sprite.rotation = angle + PI/2
	$Sprite.position = Vector2(10.5, 10) + Vector2(cos(angle), sin(angle)) * 7.5
	var ratio = lender.lend_money.get_node("LendTimer").time_left / lender.lend_money.get_node("LendTimer").wait_time
	$VBoxContainer/TextureProgress.value = ratio
	$VBoxContainer/TextureProgress.tint_progress = Color(max(0, 1.1 - ratio), ratio, 0, 1)
	$VBoxContainer/Label.text = str(amount)
		
	if lender.lend_money.is_angry:
		get_node("Head").position = Vector2(rand_range(-1, 1), rand_range(-1, 1))
		get_node("Head").modulate = Color(0.8, 0.6, 0.6, 1)
		
#func overdue():
#	removing = true
#	$Particles2D.emitting = true
#	$Timer.start()
	
func paid():
	$Timer.start()

func _on_Timer_timeout():
	$Tween.interpolate_property(self, "modulate:a", modulate.a, 0, 0.3, 0, 1)
	$Tween.start()

func _on_Tween_tween_completed(object, key):
	queue_free()
