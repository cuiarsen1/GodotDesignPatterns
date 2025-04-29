class_name Player
extends CharacterBody2D

@export var speed: float = 300.0
@export var jump_velocity: float = -400.0

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var state_machine: StateMachine = $StateMachine

const ANIM_IDLE = "idle"
const ANIM_WALK = "walk"
const ANIM_JUMP = "jump"
const ANIM_FALL = "fall"
const ANIM_ATTACK_LIGHT = "attack_light"
const ANIM_ATTACK_HEAVY = "attack_heavy"
const ANIM_ATTACK_DASH = "attack_dash"

var current_animation: String = ""

func _ready():
	if not animated_sprite: push_error("Player needs AnimatedSprite2D")
	if not state_machine: push_error("Player needs StateMachine")

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity
	
	move_and_slide()
	update_facing_direction()

func get_input_direction() -> float:
	return Input.get_axis("move_left", "move_right")

func update_facing_direction():
	if velocity.x > 0:
		animated_sprite.flip_h = false
	elif velocity.x < 0:
		animated_sprite.flip_h = true

func apply_friction(delta):
	velocity.x = move_toward(velocity.x, 0, speed * delta * 5.0)

"""func update_animation(direction: float):
	var new_animation = ANIM_IDLE # Default to idle

	# Check air state first (Jump/Fall override Idle/Run)
	
	if not is_on_floor():
		if velocity.y < 0:
			new_animation = ANIM_JUMP
		else:
			new_animation = ANIM_FALL
	else:
		# Check ground state only if on the floor
		if velocity.x != 0:
			new_animation = ANIM_WALK
		else:
			new_animation = ANIM_IDLE
	
	if Input.is_action_just_pressed("attack_light"):
		animated_sprite.play(ANIM_ATTACK_LIGHT)
		velocity.x = 0
	elif Input.is_action_just_pressed("attack_heavy"):
		animated_sprite.play(ANIM_ATTACK_HEAVY)
		velocity.x = 0
	
	if is_on_floor() and Input.is_action_just_pressed("attack_dash") and direction != 0:
		animated_sprite.play(ANIM_ATTACK_DASH)
		
	# Only play the animation if it's different from the current one
	if new_animation != current_animation:
		if animated_sprite.sprite_frames.has_animation(new_animation):
			animated_sprite.play(new_animation)
			current_animation = new_animation
		else:
			push_warning("Animation '%s' not found in AnimatedSprite2D!" % new_animation)
			if animated_sprite.sprite_frames.has_animation(ANIM_IDLE):
				animated_sprite.play(ANIM_IDLE)
				current_animation = ANIM_IDLE
"""
