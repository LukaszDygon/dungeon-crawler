extends CanvasLayer

signal rps_started
signal rps_ended

const HAND_SIZE = 128
const TRANSITION_TIME = 1

var tween: Tween
var round: int
var score_required: int
var player_score: int
var character_score: int
var character_choices: Array
var is_playing: bool = false

@onready var player = get_parent().get_node("Player")

func _process(delta):
	if (not is_playing or (tween and tween.is_running())):
		return
	handle_input()

func start(score_required: int, character_choices: Array):
	reset()
	self.score_required = score_required
	self.character_choices = character_choices
	is_playing = true
	rps_started.emit()
	show()

func end():
	is_playing = false
	rps_ended.emit()
	hide()

func handle_input():
	for key in ['rock', 'paper', 'scissors', 'gun']:
		if Input.is_action_just_pressed(key):
			play_round(key[0], character_choices[round % len(character_choices)])

func play_round(p1: String, p2: String):
	render_player(p1)
	render_npc(p2)
	animate_hands()
	var result = get_result(p1, p2)
	if result == 1:
		player_score += 1
	elif result == -1:
		character_score += 1
	round += 1
	animate_result(result)
	await tween.finished
	if character_score == score_required or player_score == score_required:
		end()
	pass

func render_player(choice: String):
	var image = Image.load_from_file("res://assets/rps/%s.png" % choice)
	image.resize(HAND_SIZE, HAND_SIZE)
	var texture = ImageTexture.create_from_image(image)
	$PlayerHand.texture = texture
	
func render_npc(choice: String):
	var image = Image.load_from_file("res://assets/rps/%s.png" % choice)
	image.resize(HAND_SIZE, HAND_SIZE)
	image.flip_y()
	var texture = ImageTexture.create_from_image(image)
	$NpcHand.texture = texture

func animate_hands():
	tween = create_tween()
	$PlayerHand.position.x -= HAND_SIZE
	$NpcHand.position.x += HAND_SIZE
	tween.set_parallel(true)
	tween.tween_property($PlayerHand, "position:x", $PlayerHand.position.x + HAND_SIZE, TRANSITION_TIME).set_trans(Tween.TRANS_SINE)
	tween.tween_property($NpcHand, "position:x", $NpcHand.position.x - HAND_SIZE, TRANSITION_TIME).set_trans(Tween.TRANS_SINE)
	await tween.finished

func animate_result(result):
	$Text/PlayerScore.text = "You: %d" % player_score
	$Text/NpcScore.text = "Opponent: %d" % character_score

	if result == -1:
		$Text/Result.text = 'Loss'
	if result == 0:
		$Text/Result.text = 'Draw'
	if result == 1:
		$Text/Result.text = 'Win'
	
	tween = create_tween()
	tween.tween_property($Text/Result, "modulate:a", 1, TRANSITION_TIME).set_trans(Tween.TRANS_SINE)
	tween.tween_property($Text/Result, "modulate:a", 0, TRANSITION_TIME).set_trans(Tween.TRANS_SINE)
	await tween.finished

func get_result(p1: String, p2: String) -> int:
	if p1 == 'g':
		if p2 == 'g':
			return 0
		return 1

	if p1 == 'r':
		if p2 == 'r':
			return 0
		if p2 == 'p':
			return -1
		if p2 == 's':
			return 1
	
	if p1 == 'p':
		if p2 == 'r':
			return 1
		if p2 == 'p':
			return 0
		if p2 == 's':
			return -1
			
	if p1 == 's':
		if p2 == 'r':
			return -1
		if p2 == 'p':
			return 1
		if p2 == 's':
			return 0
	return 0

func reset():
	player_score = 0
	character_score = 0
	round = 0
