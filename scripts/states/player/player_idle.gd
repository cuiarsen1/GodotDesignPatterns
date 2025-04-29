extends State

var direction: float

func enter():
	var anim_sprite = get_anim_sprite()
	if anim_sprite:
		anim_sprite.play(Player.ANIM_IDLE)
	
	actor.velocity.x = 0
	
func update(delta: float):
	pass
	
func physics_update(delta: float):
	if Input.is_action_just_pressed("jump"):
		actor.velocity.y = actor.jump_velocity
		emit_signal("transitioned", "PlayerJump")
		return
		
	if Input.is_action_just_pressed("attack_light"):
		emit_signal("transitioned", "PlayerAttack")
		return
		
	if actor.get_input_direction() != 0.0:
		emit_signal("transitioned", "PlayerWalk")
		return
			
	if not actor.is_on_floor():
		emit_signal("transitioned", "PlayerFall")
		return
