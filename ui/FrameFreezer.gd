extends Node


export var delay_mseconds = 25

export var enabled = false

var frozen = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	for ff in get_tree().get_nodes_in_group("frame_freezer"):
		ff.connect("frame_freeze_request", self, "_frame_freeze_requested")

func _frame_freeze_requested(duration=0.05, delay=0):
	if delay != 0:
		yield(get_tree().create_timer(delay), 'timeout')
	if not enabled or frozen: 
		return 
	frozen = 1
	get_tree().paused = true
	yield(get_tree().create_timer(duration), 'timeout')
	get_tree().paused = false
	frozen = 0
