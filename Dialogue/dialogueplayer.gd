extends Control

signal dialogue_finished
@export_file("*.json") var d_file

var dialogue = []
var current_dialogue_id = 0
var d_active = false

func _ready():
	$NinePatchRect.visible = false
	
func start():
	if d_active:
		return
	d_active = true
	$NinePatchRect.visible = true
	dialogue = load_dialogue()
	current_dialogue_id = -1
	next_script()
	
func load_dialogue():
	var file = FileAccess.open("res://Dialogue/santa_dialogue1.json", FileAccess.READ)
	var content = JSON.parse_string(file.get_as_text())
	return content
	
func _input(event):
	#if !d_active:
	#	return
	#if event.is_action_pressed("ui_accept"):
	if event.is_action_pressed("continue_dialogue") and d_active:
			next_script()

func next_script():
	current_dialogue_id += 1
	print("dialogue???? ", current_dialogue_id)
	if current_dialogue_id >= len(dialogue):
		finish_dialogue()
		return
		
	var current_entry = dialogue[current_dialogue_id]
	$NinePatchRect/Name.text = dialogue[current_dialogue_id]['name']
	$NinePatchRect/Text.text = dialogue[current_dialogue_id]['text']
	
	
func finish_dialogue():
	d_active = false
	$NinePatchRect.visible = false
	emit_signal("dialogue_finished")
	print("Dialogue finished at index: ", current_dialogue_id)
