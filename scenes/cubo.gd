extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -270
var startpos: Vector2
func _ready():
	startpos = self.position

func _physics_process(delta: float) -> void:
	if Global.mode == "cube":
		$AnimatedSprite2D.play("cube")
	# Add the gravity.
		if not is_on_floor():
			rotation_degrees += 360 * delta
			velocity += get_gravity() * delta *2
		else:
			var target_rotation = round(rotation_degrees / 90.0) * 90.0

			if abs(angle_difference(rotation, deg_to_rad(target_rotation))) < 0.01:
				rotation = deg_to_rad(target_rotation)
			else:
				rotation = lerp_angle(rotation, deg_to_rad(target_rotation), 10.0 * delta)
		# Handle jump.
		if Input.is_action_pressed("ui_accept") and is_on_floor():
			velocity.y = JUMP_VELOCITY *2
	elif Global.mode == "ship":
		rotation = velocity.angle()
		$AnimatedSprite2D.play("ship")
		
		var max_speed = 300.0
		var ship_speed = 300.0

		if Input.is_action_pressed("ui_accept"):
			if is_on_floor():
				velocity.y -= 100
			else:
				velocity -= get_gravity() * delta * 1.3
		else:
			if not is_on_floor():
				velocity += get_gravity() * delta
			else:
				velocity.y = 0

		velocity.y = clamp(velocity.y, -max_speed, max_speed)
		velocity.x = ship_speed

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := 1
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()






func _on_spixebox_area_entered(area: Area2D) -> void:
	if area is Hazard:
		self.position = startpos
		if get_parent().has_node("AudioStreamPlayer"):
			Global.mode = "cube"
			var coso = get_parent().get_node("AudioStreamPlayer")
			coso.stop()
			coso.play()


func _on_collibox_area_entered(area: Area2D) -> void:
	if area is bad:
		
		self.position = startpos
		if get_parent().has_node("AudioStreamPlayer"):
			var coso = get_parent().get_node("AudioStreamPlayer")
			coso.stop()
			Global.mode = "cube"
			coso.play()
