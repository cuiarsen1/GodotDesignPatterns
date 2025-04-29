extends State

func enter():
	var anim_sprite = get_anim_sprite()
	if anim_sprite:
		anim_sprite.play(Player.ANIM_FALL)

func physics_update(_delta):
	var direction = actor.get_input_direction()
	actor.velocity.x = direction * actor.speed * 0.8
	
	if actor.is_on_floor():
		if actor.get_input_direction() == 0.0:
			emit_signal("transitioned", "PlayerIdle")
		else:
			emit_signal("transitioned", "PlayerWalk")
		return

	if Input.is_action_just_pressed("attack_light"):
		emit_signal("transitioned", "PlayerAttack")
		return
