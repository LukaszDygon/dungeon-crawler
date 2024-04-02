class_name Character

extends CharacterBody3D

@export var entity_name = 'dog_guard'
@export var dialogue_options = {
	"": ["Hello", "I'm a character"],
	"rps": ["Let's Rock!.. paper, scissors"]
}

var dialogue_actions = {
	"": func(): pass,
	"rps": func(): play_rps()
}

@export var dialogue_requirement = {
	"": [],
	"rps": []
}

@export var rps_order = ["r", "p", "s"]
@export var rps_rounds = 1
var dialogue_options_used = []

@onready var dialogue_manager = get_parent().get_node("DialogueManager")
@onready var rps_manager = get_parent().get_node("RpsManager")
@onready var player = get_parent().get_node("Player")

func _ready():
	$Sprite3D.texture = get_avatar()

func _process(delta):
	self.look_at(player.position, Vector3(0,1,0), true)
	
func dialogue(option: String):
	var lines = dialogue_options[option]
	dialogue_manager.update_text(get_avatar(64), lines)

func action(interaction: String):
	if (interaction in dialogue_actions.keys()):
		dialogue_actions[interaction].call()

func interact(interaction: String):
	dialogue_options_used.append(interaction)
	dialogue(interaction)
	await dialogue_manager.dialogue_ended
	action(interaction)

func get_possible_interactions() -> Array[String]:
	var interactions
	for key in dialogue_requirement.keys():
		if ((dialogue_requirement[key] in player.knowledge
			or dialogue_requirement[key] in player.items)
			and key not in dialogue_options_used):
			interactions.append(key)
	return interactions

func play_rps():
	rps_manager.start(rps_rounds, rps_order)

func reset():
	dialogue_options_used = []

func get_avatar(resize: int = 0) -> ImageTexture:
	var image = Image.load_from_file("res://assets/entities/%s.png" % entity_name)
	if resize > 0:
		image.resize(resize, resize)
	var texture = ImageTexture.create_from_image(image)

	return texture
