extends State

var _can_exit: bool = false # Prevent instant exit if animation is short

func enter():
	_can_exit = false
	var anim_sprite = get_anim_sprite()
	if anim_sprite:
		anim_sprite.play(Player.ANIM_ATTACK_LIGHT)
		# Connect to animation finished signal ONLY when entering attack state
		if not anim_sprite.is_connected("animation_finished", Callable(self, "_on_animation_finished")):
			anim_sprite.animation_finished.connect(_on_animation_finished)

	# Activate Hitbox (adjust timing if needed with Timer or AnimationPlayer keyframes)
	#var hitbox = get_attack_hitbox()
	#if hitbox:
		#hitbox.activate()

	# Use a short timer to prevent exiting if the animation finishes immediately
	# Adjust wait_time if needed (e.g., 0.1 seconds)
	get_tree().create_timer(0.05, false).timeout.connect(func(): _can_exit = true)

func exit():
	# Deactivate Hitbox
	#var hitbox = get_attack_hitbox()
	#if hitbox:
		#hitbox.deactivate()

	# IMPORTANT: Disconnect the signal when exiting the state
	var anim_sprite = get_anim_sprite()
	if anim_sprite and anim_sprite.is_connected("animation_finished", Callable(self, "_on_animation_finished")):
		anim_sprite.animation_finished.disconnect(_on_animation_finished)

func physics_update(_delta):
	if not actor.is_on_floor():
		var direction = actor.get_input_direction()
		actor.velocity.x = direction * actor.speed * 0.8
	else:
		actor.apply_friction(_delta)

func _on_animation_finished():
	# Check if we are still in this state and the correct animation finished
	if state_machine.current_state == self and get_anim_sprite().animation == actor.ANIM_ATTACK_LIGHT and _can_exit:
		# Determine the state to return to based on current conditions
		if not actor.is_on_floor():
			emit_signal("transitioned", "PlayerFall")
		elif actor.get_input_direction() != 0.0:
			emit_signal("transitioned", "PlayerWalk")
		else:
			emit_signal("transitioned", "PlayerIdle")
