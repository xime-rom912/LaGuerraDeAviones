# gun.gd
extends Sprite

var Fire = preload("res://Fuego.tscn")
var Bullet = preload("res://Bullet.tscn")
		
func shot():
	var bullet = Bullet.instance()
	bullet.position = $Muzzle1.get("position")
	bullet.velocity = $Muzzle1.get("position").y * bullet.speed
	bullet.name = "misil"
	add_child(bullet)

func _process(_delta):
	#Eficiencia 		
	if Input.is_physical_key_pressed($label.text.ord_at(0)):
		add_child(Fire.instance())
		shot()
		yield(get_tree().create_timer(0.15), "timeout")
	if Input.is_physical_key_pressed($label.text.ord_at(2)):
		if rotation_degrees < 80: # v8
				rotation += 0.1
	if Input.is_physical_key_pressed($label.text.ord_at(1)):
		if rotation_degrees > -80: # v8
				rotation -= 0.1
