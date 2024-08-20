extends CharacterBody2D

var player_nearby :bool = false
var can_shoot : bool = true
var health = 40

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
	if can_shoot:
		can_shoot = false
		$ShootCooldown.start()
		var dir = ($Pivot/Shoot.global_position-global_position).normalized()
		shoot.emit($Pivot/Shoot.global_position, dir)
		$Pivot.rotate(deg_to_rad(90))
		dir = ($Pivot/Shoot.global_position-global_position).normalized()
		shoot.emit($Pivot/Shoot.global_position, dir)
		$Pivot.rotate(deg_to_rad(90))
		dir = ($Pivot/Shoot.global_position-global_position).normalized()
		shoot.emit($Pivot/Shoot.global_position, dir)
		$Pivot.rotate(deg_to_rad(90))
		dir = ($Pivot/Shoot.global_position-global_position).normalized()
		shoot.emit($Pivot/Shoot.global_position, dir)
		$Pivot.rotate(deg_to_rad(90))
	#crush
	if hovered and health <=10 and player_near:
		$Border.show()
	else:
		$Border.hide()
	#end crush

func _on_shoot_cooldown_timeout():
	can_shoot = true

#crush
func take_damage():
	health -= 10
	if health <=10:
		#$Sprite2D.material.set_shader_parameter("progress", 1)
		$LowHealth.show()
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
