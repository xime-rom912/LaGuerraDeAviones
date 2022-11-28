extends RigidBody2D

var velocity = 0
var speed = 14

func _physics_process(delta):
	position.y += velocity * delta


func _on_Bullet_body_entered(body):
	queue_free()
