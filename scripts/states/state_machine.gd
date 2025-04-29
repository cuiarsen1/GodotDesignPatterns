class_name StateMachine
extends Node

@export var initial_state: State

var states: Dictionary = {}
var current_state: State

# Reference to the owner of this state machine
@onready var actor: CharacterBody2D = get_parent() as CharacterBody2D

func _ready():
	if not actor:
		push_error("StateMachine requires a CharacterBody2D parent (the 'actor'). Failed to get or cast parent.")
		set_physics_process(false)
		set_process(false)
		return
	for child in get_children():
		if child is State:
			states[child.name] = child
			child.initialize(actor, self)
			child.transitioned.connect(_on_state_transitioned)
		else:
			push_warning("Child '%s' of StateMachine is not a State" % child.name)
			
	if initial_state and initial_state.name in states:
		initial_state.enter()
		current_state = initial_state
	elif states.size() > 0:
		push_warning("Initial state not set or invalid for StateMachine on '%s'. Defaulting to first found state: %s" % [actor.name if actor is Node else "Unknown Actor", states.keys()[0]])
		current_state = states.values()[0]
		current_state.enter()
	else:
		var owner_description = "Unknown Owner / Invalid Actor Reference"
		# Check if actor is valid and is a Node before accessing .name
		if actor is Node:
			owner_description = actor.name
		push_error("StateMachine node '%s' (intended owner: '%s') has no child State nodes! Ensure State scripts (Idle, Run, etc.) are direct children of this StateMachine." % [self.name, owner_description])
		set_physics_process(false)
		set_process(false)


func _process(delta: float):
	if current_state:
		current_state.update(delta)

func _physics_process(delta: float):
	if current_state:
		current_state.physics_update(delta)

func _on_state_transitioned(new_state_name: String):
	if not new_state_name in states:
		push_error("StateMachine on '%s' cannot transition to unknown state: %s" % [actor.name, new_state_name])
		return
		
	if current_state and current_state.name == new_state_name:
		return
		
	var new_state = states[new_state_name]
	
	if not new_state:
		return
	
	# Call exit() on the old state
	if current_state:
		current_state.exit()
		
	new_state.enter()
	
	current_state = new_state
