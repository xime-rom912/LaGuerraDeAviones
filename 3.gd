"""
 World.gd
 Alberto Pacheco
 18/10/2022 v8

To-do:
	√ Contador avión [ISSUE]
	+ Empalme torres (name=Torreta) [ISSUE]
	? Disparo 1 torre: numerar 1-3 [ISSUE]
	- Agregar sonidos, ej. explosiones
	- Agregar balas/misiles
	- Agregar Score
	- Escenario
	- Avión disparo/bomba
	√ Angulo torre 160º
"""

extends Node2D

const Enemy = preload("res://Enemy.tscn") 
const Gun = preload("res://Torreta.tscn")

const GunName = "Torre"   # v8
const PlaneName = "Enemy" # v8

const PlaneAngle = PI / 2 # v8

func _ready():
	$info.visible = true
	yield(get_tree().create_timer(3), "timeout")
	$info.visible = false
	randomize() # v7 Bug
	new_gun()
	new_plane()
	$inicio.playing = true
	get_node("/root/Score/HUD/Nivel/NivelA").text = "3"
	
func obtenerScore():
	var score = get_node("/root/Score/HUD/Score/ScoreI")
	return score
	

func count_planes(): # v8
	var count = 0
	for p in get_children():
		if PlaneName in p.name:
			count += 1
	return count

func new_plane():
	var score = int(obtenerScore().text)
	if(score > 100):
		get_tree().paused = true
		$Win.visible = true
		yield(get_tree().create_timer(4), "timeout")
		get_tree().quit(-1)
		
	if(!(count_planes() == 15)):
		var enemy = Enemy.instance()
		var fx = rand_range(-90,90) # plane velocity
		var force = Vector2(fx,rand_range(-7,9))
		enemy.set_deferred("position", Vector2(rand_range(100,924), 1))
		enemy.call_deferred("rotate",  Vector2(-fx,-90).angle()+PlaneAngle) # v8
		enemy.call_deferred("connect", "plane_quit", self, "new_plane")
		enemy.call_deferred("connect", "gun_quit", self, "change_gun")
		enemy.call_deferred("connect", "bullet_quit", self, "score_update")
		enemy.set_deferred("applied_force", force)
		call_deferred("add_child", enemy) # Bug: add_child(enemy)

func range_rnd(): return rand_range(100,924)

func new_range(x): return [x-70, x+70]

func check_x(x1, x2, x):
	if x>=x1 and x<=x2: # empalme?
		return check_x(x1, x2, range_rnd()) # create & test new x
	return x

func new_pos(lst): # v7 genera pos nva torreta evitando traslapes
	var x = range_rnd()
	if lst.size() > 0:
		for r in lst:
			x = check_x(r[0], r[1], x)
	lst.append(new_range(x))
	return Vector2(x,550)

func new_gun():
	var pos_x = [] # v7 zonas existentes generadas para torretas
	var letras =['N','M','V','B','K','L']
	var j = 0
	for i in range(3): # v7 genera 3 torretas
		var gun = Gun.instance()
		var num = String(i+1) + letras[j] + letras[j+1] 
		gun.name = GunName + num # v7 set name
		gun.get_node("gun/label").text = num # v8
		gun.position = new_pos(pos_x)
		j = j+2
		add_child(gun)

func change_gun(id): # v8 reuse torre
	var vidas = int(get_node("/root/Score/HUD/Lives/LivesA").text)
	var totalV = vidas-1
	get_node("/root/Score/HUD/Lives/LivesA").text = str(totalV)
	if(totalV <= 0):
		get_tree().paused = true
		$gameOver.visible = true
		yield(get_tree().create_timer(3), "timeout")
		get_tree().quit(-1)
	var pos_x = [] # pos. torres
	var torre = get_node(id)
	var score = 0
	if (id != null): 
		torre.destroy() # play exnplosion animation
		for obj in get_children():
			var name = obj.name
			if name.begins_with(GunName):
				if name != id:
					pos_x.append(new_range(obj.position.x))
		#yield(get_tree().create_timer(0.45), "timeout")
		torre.position = new_pos(pos_x)
	
func score_update(): #v9
	var score = obtenerScore()
	var toScore
	toScore = int(score.text)
	score.text = str(toScore+1)
