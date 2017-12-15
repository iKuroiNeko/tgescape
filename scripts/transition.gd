extends CanvasLayer

var next_path #indica pra onde vai


func fade_to(path):
	get_node("Sample").play("doorOpen")
	next_path = "res://scenes/" + path
	get_node("Anim").play("fade")
	
func change_scene():
	if next_path != null:
		get_tree().change_scene(next_path)
	
