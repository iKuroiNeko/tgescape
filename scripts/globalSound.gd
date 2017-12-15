extends Spatial

onready var sound = get_node("rainSample")

func _ready():
	sound.play("rain")

func playGlobalSound():
	sound.play("rain")

