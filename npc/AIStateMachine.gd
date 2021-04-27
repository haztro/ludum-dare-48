class State:
	
	var _name
	
	func _init(name):
		_name = name
		
	func entry_actions():
		pass
		
	func check_conditions():
		pass
		
	func do_actions(delta):
		pass
		
	func exit_actions():
		pass

class StateMachine:
	
	var _states = {}
	var _active_state = null

	func add_state(name, state):
		_states[name] = state
		
	func get_current_state():
		if _active_state != null:
			return _active_state._name
		return null
		
	func think(delta):
		
		if _active_state == null:
			return

		_active_state.do_actions(delta)
		
		var new_state_name = _active_state.check_conditions()
		if new_state_name != null:
			set_state(new_state_name)
			
	func set_state(new_state_name):
		
		if _active_state != null:
			_active_state.exit_actions()
			
		_active_state = _states[new_state_name]
		_active_state.entry_actions()
		
	
		
	
