extends CanvasLayer

@onready var health_bar = $MarginContainer2/TextureProgressBar

func _ready():
	Globals.connect("health_change", update_health_ui)
	$GameOverFade.hide()
	$GameOverLabel.hide()
	update_health_ui()

func update_health_ui():
	health_bar.value = Globals.health

func game_over():
	$GameOverFade.show()
	$GameOverLabel.show()
