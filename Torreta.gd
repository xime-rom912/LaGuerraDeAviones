# Torreta.gd
extends StaticBody2D

var Bullet = preload("res://Bullet.tscn")

func _ready():
	#$gun/label.text = name # v8
	$tween.interpolate_property(self, 'modulate:a', \
		1, 0.5, 0.4, Tween.TRANS_QUAD, Tween.EASE_OUT)
	
func destroy():
	$gun/explosion.playing = true
	yield(get_tree().create_timer(0.3), "timeout")
	$gun/explosion.playing = false
	$tween.start()	

func _on_tween_tween_all_completed():
	modulate.a = 1.0 # v8
	

