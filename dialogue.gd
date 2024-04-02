extends CanvasLayer

signal dialogue_started
signal dialogue_ended

const DIALOGUE_HEIGHT := 64
const DIALOGUE_WIDTH := 64
const TRANSITION_TIME := 1

var dialogue_queue = []
var tween

@onready var dialogue_bubble = $DialogueBubble
@onready var dialogue_text = $DialogueBubble/DialogueText
@onready var dialogue_avatar = $DialogueBubble/DialogueAvatar

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (not visible or Input.is_action_just_pressed('action')) and dialogue_queue:
		dialogue_started.emit()
		show()
		if not tween or not tween.is_running():
			var avatar = dialogue_queue[0][0]
			var text = dialogue_queue[0][1]
			dialogue_avatar.texture = avatar
			dialogue_text.text = text
			dialogue_queue.pop_front()
			
			_transition_to_next_text()

	elif visible and Input.is_action_just_pressed('action'):
		dialogue_ended.emit()
		hide()
	
	
func _transition_to_next_text():
		dialogue_bubble.modulate = Color(1, 1, 1, 0)
		dialogue_bubble.position.y = dialogue_bubble.position.y + DIALOGUE_HEIGHT
		tween = dialogue_bubble.create_tween()
		tween.set_parallel(true)
		tween.tween_property(dialogue_bubble, "position:y", dialogue_bubble.position.y - DIALOGUE_HEIGHT, TRANSITION_TIME).set_trans(Tween.TRANS_SPRING)
		tween.tween_property(dialogue_bubble, "modulate:a", 1, TRANSITION_TIME).set_trans(Tween.TRANS_SPRING)
	
	
func update_text(avatar: ImageTexture, text: Array):
	for line in text:
		dialogue_queue.append([avatar, line])
	
