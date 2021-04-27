extends Node

var ai = preload("res://npc/AIStateMachine.gd")
var brain = ai.StateMachine.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	brain.add_state("idle", IdleState.new("idle", get_parent()))
	brain.add_state("wandering", WanderingState.new("wandering", get_parent()))
	brain.add_state("chasing", ChasingState.new("chasing", get_parent()))
	brain.set_state("idle")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	brain.think(delta)

class IdleState extends "res://npc/AIStateMachine.gd".State:
	
	var _npc
	
	func _init(name, npc).(name):
		_npc = npc
	
	func entry_actions():
		_npc.clear_path()
		pass
		
	func check_conditions():
		if _npc.lend_money.is_angry:
			return "chasing"
		var ch = rand_range(0, 1.0)
		if ch <= 0.003 and !_npc.engaged:
			return "wandering"
		return null
		
	func do_actions(delta):
		_npc.direction = Vector2(0, 0)
		
	func exit_actions():
		pass

class WanderingState extends "res://npc/AIStateMachine.gd".State:
	
	var _npc
	
	func _init(name, npc).(name):
		_npc = npc
	
	func entry_actions():
		var x = clamp(_npc.position.x + rand_range(-100, 100), -380, 490)
		var y = clamp(_npc.position.y + rand_range(-100, 100), -290, 428)
		_npc.set_destination(Vector2(x, y))
		
	func check_conditions():
		if _npc.lend_money.is_angry:
			return "chasing"
		var distance = _npc.position.distance_to(_npc.destination)
		if distance < 5:
			_npc.clear_path()
			return "idle"
		return null
		
	func do_actions(delta):
		var player = GameData.player
		var distance = _npc.position.distance_to(_npc.final_destination)
		var ch = rand_range(0, 1.0)
		if ch <= 0.005:
			var x = clamp(_npc.position.x + rand_range(-100, 100), -380, 490)
			var y = clamp(_npc.position.y + rand_range(-100, 100), -270, 418)
			_npc.set_destination(Vector2(x, y))
			
		_npc.direction = (_npc.destination - _npc.position).normalized()
		
#		if _npc.position.distance_to(_npc.destination) < 1 and _npc.destination_path.size() > 0:
#			_npc.destination = _npc.destination_path[0]
#			_npc.destination_path.remove(0)

	func exit_actions():
		pass
		
class ChasingState extends "res://npc/AIStateMachine.gd".State:
	
	var _npc
	
	func _init(name, npc).(name):
		_npc = npc
	
	func entry_actions():
		var player = GameData.player
		_npc.set_destination(player.position)
		
	func check_conditions():
		if !_npc.lend_money.is_angry:
			return "idle"
		return null
		
	func do_actions(delta):
		var player = GameData.player
		if player:
			_npc.set_destination(_npc.position - (_npc.position - player.position).normalized() * 10)	
			_npc.direction = (_npc.destination - _npc.position).normalized()

	func exit_actions():
		pass
