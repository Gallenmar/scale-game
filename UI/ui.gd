extends CanvasLayer

@onready var health_bar = $MarginContainer/TextureProgressBar

func _ready():
	Globals.connect("health_change", update_health_ui)
	update_health_ui()

func update_health_ui():
	health_bar.value = Globals.health
