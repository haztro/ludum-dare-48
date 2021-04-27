extends KinematicBody2D
class_name Npc

signal camera_shake_request
signal frame_freeze_request

export(PackedScene) var ai = null

var ACCEL = 50
var MAX_SPEED = 40

var mov2D = preload("res://Movement2D.gd").new(MAX_SPEED, ACCEL)
var direction = Vector2.ZERO
var aim_direction = Vector2.ZERO
var velocity = Vector2.ZERO
var velocity_offset = Vector2.ZERO
var destination = Vector2.ZERO
var destination_path = []
var final_destination = Vector2.ZERO
var world = null
var nav2D = null
var engaged = false

onready var lend_money = get_node("LendMoney")

# Called when the node enters the scene tree for the first time.
func _ready():
	world = get_parent()
	nav2D = get_parent().get_node("Navigation2D")

func _physics_process(_delta):
	velocity = mov2D.get_velocity(direction)
	velocity = move_and_slide(velocity)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if lend_money.is_angry:
		mov2D._max_speed = 70
	else:
		mov2D._max_speed = 40
	$Body.update_body(direction)

func set_destination(dest):
	destination = dest
#	final_destination = dest
#	destination_path = nav2D.get_simple_path(position, dest) 
#	if destination_path.size() > 1:
#		destination = destination_path[1]
#		destination_path.remove(0)
#
func clear_path():
	destination_path.resize(0)
	final_destination = position
	destination = position 
	mov2D._velocity = Vector2.ZERO	

func selected():
	engaged = true
	$Tween.interpolate_property($Body, "modulate", $Body.modulate, Color(1.5, 1.5, 1.5, 1.0), 0.3, 0, 1)
	$Tween.interpolate_property($TrustHearts, "modulate:a", $TrustHearts.modulate.a, 1, 0.3, 0, 1)
	$Tween.start()
	
func deselected():
	engaged = false
	$Tween.interpolate_property($Body, "modulate", $Body.modulate, Color(1, 1, 1, 1.0), 0.3, 0, 1)
	$Tween.interpolate_property($TrustHearts, "modulate:a", $TrustHearts.modulate.a, 0, 0.3, 0, 1)
	$Tween.start()

func _on_InteractCollider_body_entered(body):
	if body.is_in_group("player"):
		GameData.select_lender(self)
		lend_money.check_game_over()

func _on_InteractCollider_body_exited(body):
	if body.is_in_group("player"):
		GameData.deselect_lender(self)
