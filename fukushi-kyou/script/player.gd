extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -300.0
var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var animated_sprite = $AnimatedSprite2D

func SetShader_BlinkIntensity(newValue: float):
	animated_sprite.material.set_shader_parameter("blink_intensity", newValue)

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta

	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		var tween = get_tree().create_tween()
		tween.tween_method(SetShader_BlinkIntensity, 1.0, 0.0, 0.5)
		velocity.y = JUMP_VELOCITY
		
	
	if velocity.y != 0:
		animated_sprite.play("jump")
	else:
		animated_sprite.play("idle")


	var direction := Input.get_axis("ui_left", "ui_right")

	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, 0.1)

	move_and_slide()

	if direction > 0:
		animated_sprite.flip_h = false
	elif direction < 0:
		animated_sprite.flip_h = true
