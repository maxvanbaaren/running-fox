extends KinematicBody2D

var max_speed = 150
var acceleration = 800
var move = Vector2.ZERO
onready var animation = get_node("AnimationPlayer")
onready var sprite = get_node("Sprite")

func _physics_process(delta):
	
	#movement
	var axis = get_axis()
	if axis == Vector2.ZERO:
		apply_friction(acceleration * delta)  
	else: 
		apply_move(axis * acceleration * delta)
	move = move_and_slide(move)
	
	#running or idle 
	if Input.is_action_pressed("move_down") or Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right") or Input.is_action_pressed("move_up"):
		animation.play("running")
	else:
		animation.play("idle")
	
	#sprite direction
	if Input.is_action_just_pressed("move_right"):
		sprite.flip_h = false
	if Input.is_action_just_pressed("move_left"):
		sprite.flip_h = true

#movement input 
func get_axis():
	var axis = Vector2.ZERO
	axis.x = int(Input.is_action_pressed("move_right")) - int(Input.is_action_pressed("move_left"))
	axis.y = int(Input.is_action_pressed("move_down")) - int(Input.is_action_pressed("move_up"))
	return axis.normalized()

#friction 
func apply_friction(amount):
	if move.length() > amount:
		move -= move.normalized() * amount
	else:
		move = Vector2.ZERO

#movement
func apply_move(amount):
	move += amount
	move = move.clamped(max_speed)
