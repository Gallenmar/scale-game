extends WorldParent

var entered = false

func _ready():
	$UI/ColorRect.hide()
	$UI/Label.hide()

func _on_entrance_body_exited(body):
	if !entered:
		
		
		
		connect_enemies()
		entered = true

func _process(_delta):
	#get_tree().get_nodes_in_group("Player")
	if get_tree().get_nodes_in_group("Enemies").size() <=0:
		$UI/ColorRect.show()
		$UI/Label.show()



