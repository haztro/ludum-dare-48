extends KinematicBody2D

signal camera_shake_request
signal frame_freeze_request

var ACCEL = 50
var MAX_SPEED = 80

var mov2D = preload("res://Movement2D.gd").new(MAX_SPEED, ACCEL)
var direction = Vector2.ZERO
var aim_direction = Vector2.ZERO
var velocity = Vector2.ZERO
var velocity_offset = Vector2.ZERO


# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _input(event):
	pass

func _physics_process(_delta):
	velocity = mov2D.get_velocity(direction)
	velocity = move_and_slide(velocity)

func _process(_delta):	

	get_aim_direction()
	get_movement_direction()
	
	$Body.update_body(direction)
	
	if Input.is_action_just_pressed("borrow"):
		if GameData.current_lender != null:
			GameData.current_lender.lend_money.interact()
		elif GameData.current_door != null:
			GameData.rent_house()
	
func get_aim_direction():
	var screen_scale = (get_viewport().size / get_viewport_rect().size)
	var mouse_pos = get_viewport().get_mouse_position() * screen_scale
	var scaled_pos = (get_global_transform_with_canvas().origin - Vector2(0, 9)) * screen_scale
	aim_direction = (mouse_pos - scaled_pos).normalized()

func get_movement_direction():
	direction = Vector2(0, 0)
	if Input.is_action_pressed("move_right"):
		direction.x += 1
	if Input.is_action_pressed("move_left"):
		direction.x -= 1
	if Input.is_action_pressed("move_down"):
		direction.y += 1
	if Input.is_action_pressed("move_up"):
		direction.y -= 1
	direction = direction.normalized()

