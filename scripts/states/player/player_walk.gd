extends State

func enter():
	var anim_sprite = get_anim_sprite()
	if anim_sprite:
		anim_sprite.play(Player.ANIM_WALK)

func physics_update(_delta):
	var direction = actor.get_input_direction()
	actor.velocity.x = direction * actor.speed
	
	if Input.is_action_just_pressed("jump"):
		actor.velocity.y = actor.jump_velocity
		emit_signal("transitioned", "PlayerJump")
		return

	if Input.is_action_just_pressed("attack_light"):
		emit_signal("transitioned", "PlayerAttack")
		return
		
	if not actor.is_on_floor():
		emit_signal("transitioned", "PlayerFall")
		return

	if direction == 0.0:
		emit_signal("transitioned", "PlayerIdle")
		return
