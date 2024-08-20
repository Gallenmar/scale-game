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
	$Button.show()


func _on_button_pressed():
	get_tree().reload_current_scene()
	Globals.health = 50
	$GameOverFade.hide()
	$GameOverLabel.hide()
	$Button.hide()

