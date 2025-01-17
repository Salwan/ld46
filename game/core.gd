extends Area2D

export(float) var health:float = 100.0
var hp:float

var damageEffectTimer = 0.0

func _ready():
	hp = health

func _physics_process(delta):
	if damageEffectTimer > 0.0:
		damageEffectTimer -= delta
		if damageEffectTimer <= 0.0:
			$core.modulate = Color(0.9, clamp(hp / health, 0.0, 1.0), 0.5 + clamp((hp / health) * 0.5, 0.0, 0.5))
	rotation += PI * delta / 10.0

func damage(amount:float):
	$sound_hit.play()
	$core.modulate = Color(0.6, 0.2, 0.2)
	damageEffectTimer = 0.05
	hp -= amount
	$anim.playback_speed = 1 + ((1.0 - (hp / health)) * 6.0)
	if hp < 0.0:
		Global.game_over()
	print("HP damage: " + str(hp))

func heal(amount:float):
	$sound_heal.play()
	$core.modulate = Color(0.2, 0.6, 0.2)
	damageEffectTimer = 0.05
	hp = min(hp + amount, health)
	$anim.playback_speed = 1 + ((1.0 - (hp / health)) * 6.0)
	print("HP heal: " + str(hp))

func _on_core_body_entered(body):
	if body.is_in_group("enemy"):
		damage(body.damage)
		body.explode()
	elif body.is_in_group("powerup"):
		if body.powerType == "heal":
			heal(body.healAmount)
			body.consume()

# Returns a random point inside the core circle
func get_random_point():
	return Global.random_point_in_circle($collision.global_position, $collision.shape.radius)
