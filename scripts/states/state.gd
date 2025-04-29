class_name State
extends Node

signal transitioned(new_state_name: String)

# Set this from the StateMachine.
var actor: CharacterBody2D
var state_machine: Node

func initialize(_actor: CharacterBody2D, _state_machine: Node):
	self.actor = _actor
	self.state_machine = _state_machine

func enter():
	pass
	
func exit():
	pass
	
func update(_delta: float):
	pass
	
func physics_update(_delta: float):
	pass

func get_anim_sprite() -> AnimatedSprite2D:
	# Assumes AnimatedSprite2D is a direct child of the actor
	if actor and actor.has_node("AnimatedSprite2D"):
		return actor.get_node("AnimatedSprite2D") as AnimatedSprite2D
	push_error("Actor '%s' or its AnimatedSprite2D node not found for state '%s'." % [actor.name if actor else "null", name])
	return null
