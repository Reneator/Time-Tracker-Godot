extends VBoxContainer



var running = false

var current_block_duration = 0.0
var current_block_start_time

var current_day_duration = 0.0

export (NodePath) var state_label_path
onready var state_label = get_node(state_label_path)

export (NodePath) var current_duration_label_path
onready var current_duration_label = get_node(current_duration_label_path)

export (NodePath) var current_block_start_time_label_path
onready var current_block_start_time_label = get_node(current_block_start_time_label_path)

export (NodePath) var current_day_duration_label_path
onready var current_day_duration_label = get_node(current_day_duration_label_path)


func _process(delta):
	if not running:
		return
	current_day_duration += delta * 1000
	current_block_duration += delta * 10
	
	set_labels()

func set_labels():
	state_label.text = get_state()
	current_duration_label.text = get_duration_as_string(current_block_duration)
	current_block_start_time_label.text = get_date_string(current_block_start_time)
	current_day_duration_label.text = get_duration_as_string(current_day_duration)
	

func get_state():
	if running:
		return "Running"
	else:
		return "Paused"

func get_duration_as_string(duration): # format of 1h 30m 20s
	var seconds = int(duration)
	var minutes = int(floor(duration / 60))
	seconds = seconds % 60
	var hours = int(floor(minutes/60))
	minutes = minutes % 60
	var text = ""
	if hours > 0:
		text += str(hours) + "h "
	if minutes > 0 or hours > 0:
		text += str(minutes) + "m "
	text += str(seconds) + "s"
	return text

func get_date_string(date_time):
	return "%d:%d" % [date_time.get("hour"), date_time.get("minute")]


func _on_Start_Button_pressed():
	running = true
	if not current_block_start_time:
		current_block_start_time = OS.get_datetime()
	


func _on_Stop_Button_pressed():
	running = false
	current_block_duration = 0
