extends "res://src/bodies/characters.gd"
"""
Script base dos Personagens do Jogador.
"""
const SMOOTHNESS = 5
export(int, 0, 9999) var strength: int = 1
onready var animation_player: AnimationPlayer = $AnimationPlayer
var is_atacking: bool setget set_is_atacking
onready var weapon_ray: RayCast2D = $Weapon


func _ready() -> void:
	get_tree().call_group("enemies", "set_player", self)


func _input(event: InputEvent) -> void:
	
	if event.is_action_pressed("attack"):
		_attack()


func _physics_process(delta: float) -> void:
	
	_move(delta)
	_look(delta, get_local_mouse_position())
	
	if is_atacking and weapon_ray.is_colliding():
		damage_body(weapon_ray.get_collider())


func damage_body(body: Node) -> void:
	
	if body.has_method("take_damage"):
		body.take_damage(strength)


func _move(delta: float) -> void:
	"""
	Move o player de acordo com os eixos recebidos pelo input do jogador.
	"""
	var axis = get_input_axis()
	
	if axis == Vector2.ZERO:
		apply_friction(acceleration * delta)
		
	else:
		apply_movement(axis * acceleration * delta)
	
	move_and_collide(motion * delta)


func _look(delta: float, relative_position: Vector2) -> void:
	"""
	Rotaciona o Player em direção à posição indicada.
	"""
	rotation += relative_position.angle() * delta * SMOOTHNESS


func _attack() -> void:
	animation_player.play("attack")


func get_input_axis() -> Vector2:
	"""
	Retorna um eixo (vetor de direção) conforme as teclas pressionadas pelo jogador.
	"""
	return Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	).normalized()


func set_is_atacking(value: bool) -> void:
	is_atacking = value
