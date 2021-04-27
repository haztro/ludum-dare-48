extends Node

const START_AMOUNT = 30
const START_LEND_TIME = 30
const START_COOLDOWN = 30

const TIER1_RENT = 40
const TIER2_RENT = 80	
const TIER3_RENT = 160
const RENT_TIME = 30
const FOOD_TIME = 10
const FOOD_COST = 10

const NUM_NPCS = 20

const PRICES = [TIER1_RENT, TIER2_RENT, TIER3_RENT]

var cash = 100
var debt = 0

var current_lender = null
var player = null
var main = null
var current_door = null

var current_rent = 0

var tier = 1


# Called when the node enters the scene tree for the first time.
func _ready():
#	player = get_tree().get_nodes_in_group("player")[0]
	print(player)
	
func pay_rent():
	if cash >= current_rent:
		update_cash(-current_rent)
	else:
		return false
	return true
	
func pay_food():
	if cash >= FOOD_COST:
		update_cash(-FOOD_COST)
	else:
		return false
	return true

func rent_house():
	if cash >= PRICES[tier - 1]:
		current_rent = PRICES[tier - 1]
		tier += 1
		current_door.queue_free()
		current_door = null
		update_cash(-current_rent)
		main.get_node("RentTimer").wait_time = RENT_TIME
		main.get_node("RentTimer").start()
		Hud.set_rent_label(current_rent)
		AudioManager.play("paid")
	else:
		AudioManager.play("denied")

func game_over():
	cash = 100
	debt = 0
	current_lender = null
	player = null
	main = null
	tier = 1
	AudioManager.play("death")
	Hud.fade_out()
	Hud.restart()
	get_tree().reload_current_scene()
	
func update_cash(amount):
	cash = max(cash + amount, 0)
	Hud.update_cash_label(int(cash))
	
func update_debt(amount):
	debt = max(debt + amount, 0)
	Hud.update_debt_label(int(debt))
	
func verify_payback(owed):
	return cash >= owed
	
func get_trust_increase(time_taken, amount):
	return 1
	
func get_lend_amount(trust):
	var val = int(START_AMOUNT + trust * rand_range(30, 60) + rand_range(0, 15))
	print("LENDING: ", val)
	return val
	
func get_lend_time(amount, trust):
	var val = int(START_LEND_TIME + amount / 6 + trust * 8)
	print("LEND TIME: ", val)
	return val
	
func get_lend_cooldown(amount, trust):
	var val = int(START_COOLDOWN + amount / 20 - trust * 12)
	print("COOLDOWN: ", val)
	return val

func select_lender(lender: Npc):
	current_lender = lender
	current_lender.selected()
	Hud.show_borrow_prompt(current_lender)
	
func deselect_lender(lender: Npc):
	lender.deselected()
	if current_lender == lender:
		current_lender.deselected()
		current_lender = null
		Hud.hide_borrow_prompt()
