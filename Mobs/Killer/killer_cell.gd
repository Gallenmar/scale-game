extends CharacterBody2D

var player_nearby :bool = false
var can_shoot : bool = true
var health = 40
var timer = 1
#crush
var player_near = true
var hovered = false
signal dead(pos:Vector2)
signal crush(pos)
#end crush

signal shoot(pos, direction)

func _ready():
	#crush
	$LowHealth.hide()
	$Border.hide()

func _process(_delta):
	if(player_nearby):
		$Pivot.look_at(Globals.player_pos)
		if can_shoot:
			var pos:Vector2 = $Pivot/Shoot.global_position
			var dir:Vector2 = (Globals.player_pos - position).normalized()
			shoot.emit(pos, dir)
			can_shoot = false
			$ShootCooldown.start()
	#crush
	if hovered and health <=10 and player_near:
		$Border.show()
	else:
		$Border.hide()
	#end crush

func _on_attack_area_body_entered(_body):
	player_nearby = true


func _on_attack_area_body_exited(_body):
	player_nearby = false


func _on_shoot_cooldown_timeout():
	can_shoot = true

#crush
func take_damage():
	health -= 10
	if health <=10:
		#$Sprite2D.material.set_shader_parameter("progress", 1)
		$"LowHealth/Low Health Flickering".start()
	if health<=0:
		dead.emit(global_position)
		queue_free()

func jump_away(dir):
	var tween = get_tree().create_tween()
	tween.tween_property($".", "global_position", global_position+ dir*200 ,0.2)

func _on_hover_area_input_event(viewport, event, shape_idx):
	if Input.is_action_just_pressed("dash") and $Border.visible:
		crush.emit(global_position)
		queue_free()
		dead.emit(global_position)


func _on_hover_area_mouse_entered():
	hovered = true


func _on_hover_area_mouse_exited():
	hovered = false



func _on_crush_distance_body_entered(body):
	player_near = true


func _on_crush_distance_body_exited(body):
	player_near = false

#end crush

func _on_low_health_flickering_timeout():
	if timer == 1:
		$LowHealth.show()
		timer = 2
	else:
		$LowHealth.hide()
		timer = 1
