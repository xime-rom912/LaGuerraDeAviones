# Fuego.gd
extends Node2D

func _ready():
	$tween.interpolate_property($fuego, 'scale', \
		Vector2(0.1,0.2), Vector2(1,1.5), 0.3, Tween.TRANS_QUAD, Tween.EASE_OUT)
	$tween.interpolate_property($fuego, 'modulate:a', \
		1, 0, 0.3, Tween.TRANS_QUAD, Tween.EASE_OUT)
	$tween.start()

func _on_Tween_tween_all_completed():
	queue_free()
