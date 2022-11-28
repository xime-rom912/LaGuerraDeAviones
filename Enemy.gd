# Enemy.gd: Planes
extends RigidBody2D

signal plane_quit
signal gun_quit
signal bullet_quit

func quit_signal():
	emit_signal("plane_quit")
	queue_free()

func _on_exit_screen_screen_exited(): # out-of-screen
	quit_signal()
	
func _on_Enemy_body_entered(body): # collision
	if(!(body.name.ord_at(1) == 109)):
		emit_signal("gun_quit", body.name) # v8
		$pum.playing = true
		$humo.show()
		yield(get_tree().create_timer(0.3), "timeout")
		$pum.playing = false
	else:
		emit_signal("bullet_quit")
		$pum.playing = true
		$humo.show()
		yield(get_tree().create_timer(0.3), "timeout")
		$pum.playing = false
	quit_signal()
