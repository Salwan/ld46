extends Node2D

func _ready():
	$particles.emitting = true

func _process(delta):
	if not $particles.emitting:
		queue_free()
