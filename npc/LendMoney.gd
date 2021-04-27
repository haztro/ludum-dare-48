extends Node2D

signal camera_shake_request

var amount = 0
var trust = 0

var can_lend = true
var is_waiting = false
var is_angry = false

var lender_stats = null

# Called when the node enters the scene tree for the first time.
func _ready():
	amount = GameData.get_lend_amount(trust)
	get_parent().get_node("TrustHearts").update_trust(trust)
	connect("camera_shake_request", GameData.player.get_node("Camera"), "_camera_shake_requested")

func check_game_over():
	if is_angry:
		$Particles2D3.restart()
		$Particles2D3.position = GameData.player.position - get_parent().position
		$Particles2D3.emitting = true
		if !GameData.verify_payback(amount):
			GameData.game_over()
		else:
			payback_reluctant()

			
func payback_reluctant():
	GameData.update_cash(-amount)
	GameData.update_debt(-amount)
	
	trust = 0
	amount = GameData.get_lend_amount(trust)
	
	$LendTimer.stop()
	$CooldownTimer.wait_time = GameData.get_lend_cooldown(amount, trust)
	$CooldownTimer.start()
	
	is_waiting = false
	can_lend = false
	is_angry = false
	get_parent().get_node("Label").visible = 0
	Hud.show_borrow_prompt(get_parent())
	lender_stats.paid()
	get_parent().get_node("TrustHearts").update_trust(trust)
	emit_signal("camera_shake_request")
	AudioManager.play("hit")
	# Something that fucks you up

func interact():
	if can_lend and !is_waiting:
		lend()
	elif is_waiting:
		payback()
	else:
		AudioManager.play("denied")
		emit_signal("camera_shake_request", 0.1, 1)

func lend():
	GameData.update_cash(amount)
	GameData.update_debt(amount)
	
	$LendTimer.wait_time = GameData.get_lend_time(amount, trust)
	$LendTimer.start()
	
	is_waiting = true
	Hud.show_borrow_prompt(get_parent())
	Hud.add_lender(get_parent())
	GameData.player.get_node("Particles2D").restart()
	GameData.player.get_node("Particles2D").emitting = true
	AudioManager.play("lend")
		
func payback():
	if GameData.verify_payback(amount):
		GameData.update_cash(-amount)
		GameData.update_debt(-amount)
		
		trust += 1
		amount = GameData.get_lend_amount(trust)
		
		$LendTimer.stop()
		$CooldownTimer.wait_time = GameData.get_lend_cooldown(amount, trust)
		$CooldownTimer.start()
		
		is_waiting = false
		can_lend = false
		is_angry = false
		get_parent().get_node("Label").visible = 0
		Hud.show_borrow_prompt(get_parent())
		lender_stats.paid()
		get_parent().get_node("TrustHearts").update_trust(trust)
		$Particles2D.restart()
		$Particles2D.emitting = true
		AudioManager.play("paid")
	else:
		AudioManager.play("denied")

func _on_CooldownTimer_timeout():
	can_lend = true
	Hud.show_borrow_prompt(get_parent())

func _on_LendTimer_timeout():
	is_angry = true
	get_parent().get_node("Label").visible = 1
	if get_parent().engaged:
		check_game_over()
	Hud.show_borrow_prompt(get_parent())
