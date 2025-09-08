extends Node2D


@onready var slime: CharacterBody2D = $Slime
@onready var door: StaticBody2D = $Door
@onready var turret: Node2D = $Turret
@onready var exit: Label = $Labels/Exit


func _ready():
	var slime_health_component = slime.get_node("HealthComponent")
	if slime_health_component:
		slime_health_component.has_died.connect(_on_slime_died.bind(slime))
	var turret_health_component = turret.get_node("HealthComponent")
	if turret_health_component:
		turret_health_component.has_died.connect(_on_turret_died.bind(turret))

func _on_slime_died(slime):
	door.open()

func _on_turret_died(turret):
	exit.visible = true
