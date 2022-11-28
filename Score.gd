extends CanvasLayer

func _ready():
	pass
	
func _process(delta):
	var minutos = int(get_node("HUD/Timer").get_time_left()) / 60
	var segundos = int(get_node("HUD/Timer").get_time_left()) % 60
	$HUD/Time.set_text(str(minutos) + ":" + str(segundos))
	
func showMenu():
	$Menu.visible = !$Menu.visible
	pause()
	
func pause():
	get_tree().paused = !get_tree().paused

func texto():
	if(!$Menu.visible):
		$HUD/Pause.text = "Continuar"
	else:
		$HUD/Pause.text = "Pausa"

func _on_Timer_timeout():
	showMenu()

func _on_Pause_pressed():
	print(obtenerNivel())
	if (obtenerNivel() == "1"):
		$Menu/Vbox/GoBack.disabled = true
	else:
		$Menu/Vbox/GoBack.disabled = false
	texto()
	showMenu()

func _on_Exit_pressed():
	get_tree().quit(-1)


func _on_Continue_pressed():
	texto()
	showMenu()

func obtenerNivel():
	return $HUD/Nivel/NivelA.text 

func _on_GoBack_pressed():
	var nivel = obtenerNivel()
	if(nivel == "2"):
		get_tree().change_scene("res://1.tscn")
	if(nivel == "3"):
		get_tree().change_scene("res://2.tscn")
