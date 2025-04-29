class_name HitBox
extends Area2D

@export var damage: int = 10
@export var knockback_amount: int = 100

var collision_shape: CollisionShape2D

# Keep track of hurtboxes already hit during this activation to prevent multi-hits
var hit_targets: Array[Hurtbox] = []
var active: bool = false

func _ready():
	# Ensure there is a CollisionShape2D child
	collision_shape = get_node_or_null("CollisionShape2D") as CollisionShape2D
	if not collision_shape:
		push_error("Hitbox node '%s' requires a CollisionShape2D child." % name)
		return

	# Connect the signal. We only care when an Area enters (our Hurtbox).
	area_entered.connect(_on_area_entered)

	# Start disabled by default
	deactivate()

# Call this from the owner (e.g., character during attack animation) to activate the hitbox
func activate():
	if not collision_shape: return
	active = true
	hit_targets.clear() # Clear previous targets for this activation
	collision_shape.disabled = false


# Call this from the owner to deactivate the hitbox (e.g., end of attack animation)
func deactivate():
	if not collision_shape: return
	active = false
	collision_shape.disabled = true
	# Ensure monitoring is off if you want to save performance when inactive
	# monitoring = false # Generally okay to leave monitoring on, disabling shape is enough
