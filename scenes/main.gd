extends Node2D

@export var available_levels : Array [LevelData]


func _ready() -> void:
	LevelManager.main_scene = self
	LevelManager.levels = available_levels
