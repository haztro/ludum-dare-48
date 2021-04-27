extends CanvasLayer


var player = null
var lender_stats = preload("res://ui/LenderStats.tscn")

onready var prompt_label = get_node("MarginContainer/VBoxContainer/Label")
onready var cash_label = get_node("MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/HBoxContainer/CashLabel")
onready var debt_label = get_node("MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/HBoxContainer2/DebtLabel")
onready var container = get_node("MarginContainer/VBoxContainer/HBoxContainer/ScrollContainer/HBoxContainer")

# Called when the node enters the scene tree for the first time.
func _ready():
	$ColorRect.color.a = 1
	get_tree().root.connect("size_changed", self, "_on_viewport_size_changed")
	_on_viewport_size_changed()
	restart()

func _on_viewport_size_changed():
	$MarginContainer.rect_size = get_viewport().size
	$ColorRect.rect_size = get_viewport().size
	
func add_lender(lender: Npc):
	var ls = lender_stats.instance()
	ls.amount = lender.lend_money.amount
	var h1 = lender.get_node("Body").get_node("HeadSprite").duplicate()
	var h2 = lender.get_node("Body").get_node("HairSprite").duplicate()
	var h3 = lender.get_node("Body").get_node("HatSprite").duplicate()
	var m1 = lender.get_node("Body").get_node("HeadSprite").get_material()
	var m2 = lender.get_node("Body").get_node("HeadSprite").get_material()
	
	var n = Node2D.new()
	
	h1.frame = 0
	h1.position = Vector2(11, 13)
	h2.frame = 0
	h2.position = Vector2(11, 13)
	h3.frame = 0
	h3.position = Vector2(11, 13)
	
	n.add_child(h1)
	n.add_child(h2)
	n.add_child(h3)
	n.name = "Head"
	
	ls.add_child(n)
	
	ls.lender = lender
	lender.lend_money.lender_stats = ls
	
	container.add_child(ls)
	
func restart():
	update_cash_label(GameData.cash)
	update_debt_label(GameData.debt)
	set_rent_label(0)
	set_food_label(GameData.FOOD_COST)
	for c in container.get_children():
		container.remove_child(c)
		c.queue_free()
	fade_in()
	
func set_rent_label(val):
	$MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/HBoxContainer3/VBoxContainer/Label.text = str(val)
	
func set_food_label(val):
	$MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/HBoxContainer3/VBoxContainer2/Label.text = str(val)
		
func set_rent_icon(val):
	$MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/HBoxContainer3/VBoxContainer/TextureProgress.value = val
	
func set_food_icon(val):
	$MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/HBoxContainer3/VBoxContainer2/TextureProgress.value = val

func update_cash_label(amount):
	cash_label.set_number(amount)
	
func update_debt_label(amount):
	debt_label.set_number(amount)

func show_borrow_prompt(lender: Npc):
	if lender.lend_money.is_waiting:
		show_prompt("Pay back")
	elif !lender.lend_money.is_waiting and lender.lend_money.can_lend:
		show_prompt("Borrow " + str(lender.lend_money.amount))
	else:
		hide_prompt()
	
func hide_borrow_prompt():
	hide_prompt()
	
func show_prompt(prompt):
	if prompt != "":
		prompt_label.text = prompt
		$Tween.interpolate_property(prompt_label, "modulate:a", prompt_label.modulate.a, 1, 0.1, Tween.EASE_IN, 0) 
		$Tween.start()
	
func hide_prompt():
	$Tween.interpolate_property(prompt_label, "modulate:a", prompt_label.modulate.a, 0, 0.1, Tween.EASE_IN, 0) 
	$Tween.start()
	
func fade_in_ui():
	$Tween.interpolate_property($MarginContainer, "modulate:a", $MarginContainer.modulate.a, 1, 1, 0, 2)
	$Tween.start()
	
func fade_out_ui():
	$Tween.interpolate_property($MarginContainer, "modulate:a", $MarginContainer.modulate.a, 0, 1, 0, 2)
	$Tween.start()

func fade_in():
	$Tween.interpolate_property($ColorRect, "color:a", $ColorRect.color.a, 0, 0.5, 0, 2)
	$Tween.start()
	
func fade_out():
	$Tween.interpolate_property($ColorRect, "color:a", $ColorRect.color.a, 1, 0.5, 0, 2)
	$Tween.start()


