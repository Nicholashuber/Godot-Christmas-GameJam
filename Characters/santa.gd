extends CharacterBody2D

const speed = 30
const TILE_SIZE = 16
var current_state = SIDE_LEFT

var dir = Vector2.RIGHT
var start_pos

var is_roaming = true
var is_chatting = false

var player
var player_in_chat_zone = false




enum {
	IDLE,
	NEW_DIR,
	MOVE
}

func _ready():
	randomize()
	start_pos = position
func _process(_delta):
	if current_state == 0 or current_state ==1:
		$AnimatedSprite2D.play("idle")
	elif current_state == 2 and !is_chatting:
		if dir.x == -1:
			$AnimatedSprite2D.play("walk_w")
		if dir.x == 1:
			$AnimatedSprite2D.play("walk_e")
		if dir.y == -1:
			$AnimatedSprite2D.play("walk_n")
		if dir.y == 1:
			$AnimatedSprite2D.play("walk_s")

	if is_roaming:
		match current_state:
			IDLE:
				pass
			NEW_DIR:
				dir = choose([Vector2.RIGHT, Vector2.UP, Vector2.LEFT, Vector2.DOWN])
			MOVE:
				move(_delta)
	if Input.is_action_just_pressed("chat"):
		#if Input.is_action_just_pressed("chat") and not is_chatting:
		print("chatting with santa")
		$Dialogue.start()
		is_roaming = false
		is_chatting = true
		$AnimatedSprite2D.play("idle")

func choose(array):
	array.shuffle()
	return array.front()
	
func move(delta):
	if !is_chatting:
		#position += dir * speed * delta
		var new_position = position + dir * speed * delta

		# Ensure the character doesn't move more than 1 tile from the start position
		new_position.x = clamp(new_position.x, start_pos.x - TILE_SIZE, start_pos.x + TILE_SIZE)
		new_position.y = clamp(new_position.y, start_pos.y - TILE_SIZE, start_pos.y + TILE_SIZE)

		position = new_position

		
		


func _on_chat_detection_area_body_entered(body):
	if body.has_method("player"):
		player = body
		player_in_chat_zone = true


func _on_chat_detection_area_body_exited(body):
	if body.has_method("player"):
		player_in_chat_zone = false


func _on_timer_timeout():
	$Timer.wait_time = choose([.05,1,1.5])
	current_state = choose([IDLE,NEW_DIR,MOVE])


func _on_dialogue_dialogue_finished():
	is_chatting = false
	is_roaming = true
