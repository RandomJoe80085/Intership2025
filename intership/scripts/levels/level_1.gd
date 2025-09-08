extends Node2D

@onready var turret: Node2D = $Turret
@onready var door: Door = $Door


func _ready() -> void:
	var turret_health_component = turret.get_node("HealthComponent")
	if turret_health_component:
		turret_health_component.has_died.connect(_on_turret_died.bind(turret))

func _on_turret_died(turret):
	door.open()
