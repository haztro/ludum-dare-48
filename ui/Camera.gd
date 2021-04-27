extends Camera2D

export var max_amplitude = 6
var shake = 0

func _ready():
	connect_to_shakers()
	
func _process(_delta):
	shake_camera()
		
func shake_camera():
	offset = shake * Vector2(rand_range(-1, 1), rand_range(-1, 1))
		
func _camera_shake_requested(duration=0.1, amplitude=2):
	print("HERE")
	shake = min(amplitude, max_amplitude)
	if !$Timer.is_stopped():
		$Timer.wait_time += duration
	else:
		$Timer.wait_time = duration
		$Timer.start()
		
func release_target(velocity):
	pass

func _on_Timer_timeout():
	shake = 0
		
func connect_to_shakers():
	for cs in get_tree().get_nodes_in_group("camera_shaker"):
		print(cs)
		cs.connect("camera_shake_request", self, "_camera_shake_requested")

