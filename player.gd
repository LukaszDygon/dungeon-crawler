class_name Player

extends Node3D

signal death

const MOVE_TIME := 0.3

var _next_move = null
var tween
var strength = 1
var charisma = 1
var energy = 10
var health = 10

var items = []
var knowledge = []
var is_interacting = false

@onready var raycast_forward := $RayCastForward
@onready var raycast_backward := $RayCastBackward
@onready var raycast_left := $RayCastLeft
@onready var raycast_right := $RayCastRight
@onready var initial_position = position

func _physics_process(delta):
	if not is_interacting:
		handle_input()
		handle_movement()
		
func handle_input():
	for key in ["left", "right", "forward", "backward", "turn_left", "turn_right"]:
		if Input.is_action_just_pressed(key) or (not _next_move and not tween and Input.is_action_pressed(key)):
			_next_move = key
		if Input.is_action_just_pressed("action"):
			_next_move = "action"

func handle_movement():
	if (tween and tween.is_running()):
		return
	if _next_move == "left" and not raycast_left.is_colliding():
		tween = create_tween()
		tween.tween_property(self, "transform", transform.translated_local(Vector3.LEFT * 2), MOVE_TIME)
	if _next_move == "right" and not raycast_right.is_colliding():
		tween = create_tween()
		tween.tween_property(self, "transform", transform.translated_local(Vector3.RIGHT * 2), MOVE_TIME)
	if _next_move == "forward" and not raycast_forward.is_colliding():
		tween = create_tween()
		tween.tween_property(self, "transform", transform.translated_local(Vector3.FORWARD * 2), MOVE_TIME)
	if _next_move == "backward" and not raycast_backward.is_colliding():
		tween = create_tween()
		tween.tween_property(self, "transform", transform.translated_local(Vector3.BACK * 2), MOVE_TIME)
	if _next_move == "turn_left":
		tween = create_tween()
		tween.tween_property(self, "transform:basis", transform.basis.rotated(Vector3.UP, PI/2), MOVE_TIME)
	if _next_move == "turn_right":
		tween = create_tween()
		tween.tween_property(self, "transform:basis", transform.basis.rotated(Vector3.UP, -PI/2), MOVE_TIME)
	if _next_move == "action":
		var collider = raycast_forward.get_collider()
		if collider and collider is Character:
			collider.interact("rps")
	_next_move = null

func toggle_is_interacting():
	is_interacting = !is_interacting

func hit(magnitude):
	health -= magnitude
	if health < 1:
		death.emit()

func reset():
	strength = 1
	energy = 10
	health = 10
	items = []
	position = initial_position
