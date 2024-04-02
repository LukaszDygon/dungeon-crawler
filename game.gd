extends Node3D

@onready var npcs = get_tree().get_nodes_in_group('npcs') as Array[Character]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _ready():
	$Player.death.connect(_on_player_death)
	$DialogueManager.dialogue_started.connect(_on_dialogue_manager_dialogue_started)
	$DialogueManager.dialogue_ended.connect(_on_dialogue_manager_dialogue_ended)
	$RpsManager.rps_ended.connect(_on_rps_manager_rps_ended)
	$RpsManager.rps_started.connect(_on_rps_manager_rps_started)

func _process(delta):
	
	pass

func _on_dialogue_manager_dialogue_started():
	$Player.is_interacting = true

func _on_dialogue_manager_dialogue_ended():
	$Player.is_interacting = false

func _on_rps_manager_rps_started():
	$Player.is_interacting = true

func _on_rps_manager_rps_ended():
	$Player.is_interacting = false

func _on_player_death():
	reset()
	_display_death_screen()

func _display_death_screen():
	pass
	
func reset():
	for npc in npcs:
		npc.reset()
	$Player.reset()
	
